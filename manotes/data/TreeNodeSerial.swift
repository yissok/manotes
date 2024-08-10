import Foundation
import SwiftData


class TreeNodeSerial {
    var nodesGlobal: [TreeNode]
    var context: ModelContext
    var currentNode:TreeNode
    var nodeToMove:TreeNode
    var movingNode:Bool
    var stack: [TreeNode]
    var element: String
    var noteDate: String
    var noteAdded: TreeNode

    init(nodesGlobal: [TreeNode], context:ModelContext) {
        self.nodesGlobal = nodesGlobal
        self.context = context
        currentNode=nodesGlobal.filter { $0.name == LB_ROOT }.first!
        nodeToMove=TreeNode(content: "", name: "", parent: nil)
        movingNode=false
        stack=[]
        element=""
        noteDate="0"
        noteAdded=TreeNode(content: "", name: "", parent: nil)
    }
    
    convenience init(nodesGlobal: [TreeNode], context:ModelContext, noteDate: String) {
        self.init(nodesGlobal: nodesGlobal, context:context)
        self.noteDate=noteDate
    }
    
    func serialise(_ node:TreeNode) -> String{
        var serialisedTMP:String=""
        if isFolder(node) {
            serialisedTMP+=node.name+"-"
            for child in node.children!.sorted(by: { $0.name < $1.name }) {
                serialisedTMP+=serialise(child)+(isFolder(child) ? "_-" : "")
            }
        } else {
            serialisedTMP+=node.name+":"+node.content!+"-"
        }
        return serialisedTMP
    }
    
    enum FlowContinuation {
        case proceed
        case skip
        case stop
    }
    
    func insertTree(_ serialisedTree: String) -> TreeNode {
        var elements = serialisedTree.split(separator: "-")
        for elementSub in elements {
            var toBeContinued = FlowContinuation.proceed
            element = String(elementSub)
            if invalidLoop() {
                return TreeNode(content: "", name: "", parent: nil)
            }
            if element == "_" {
                toBeContinued = goParentDir()
            } else if element.contains("!") {
                toBeContinued = deleteNode()
            } else if element.contains(":") {
                toBeContinued = addNote()
            } else if element.contains("<>") {
                toBeContinued =  moveNode()
            } else {
                toBeContinued = enterChildDir()
            }
            switch toBeContinued {
                case FlowContinuation.stop:
                    return TreeNode(content: "", name: "", parent: nil)
                case FlowContinuation.skip:
                    continue
                default:
                    ()
            }
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
                return TreeNode(content: "", name: "", parent: nil)
            }
        }
        commit(serialisedTree)
        return noteAdded
    }
    
    func invalidLoop() -> Bool{
        if movingNode {
            if element == nodeToMove.name {
                return true
            }
        }
        return nodeToMove.name != "" && element == (nodeToMove.name+"<>")
    }
    
    func goParentDir() -> FlowContinuation{
        if stack.count==0 {
            print("malformed tree, going above root level")
            return FlowContinuation.stop
        }
        stack.removeLast()
        if let parent = stack.last {
            currentNode = parent
        }
        return FlowContinuation.proceed
    }
    
    func deleteNode() -> FlowContinuation {
        let matching = nodesGlobal.filter { $0.name == element.dropLast() }
        if matching.count==0 {
            return FlowContinuation.skip
        }
        deleteTag(matching.first!, context)
        if matching.first!.content == nil {
            // TODO: rewrite file with all tagfolders
        }
        return FlowContinuation.proceed
    }
    
    func addNote() -> FlowContinuation {
        let note = unwrapNote(noteStr: String(element), noteDate: noteDate)
        let noteNode = TreeNode(content: (note.enc ? "@" : "")+note.content!, name: note.name, parent: currentNode)
        noteAdded = noteNode
        currentNode.children!.append(noteNode)
        context.insert(noteNode)
        return FlowContinuation.proceed
    }
    
    func moveNode() -> FlowContinuation {
        let moveEl = element.replacingOccurrences(of: "<>", with: "")
        if(!movingNode) {
            movingNode=true
            currentNode=nodesGlobal.filter { $0.name == moveEl }.first!
            nodeToMove=currentNode
            return FlowContinuation.skip
        }
        var newParent = nodesGlobal.filter { $0.name == moveEl }.first!
        nodeToMove.parent=newParent
        newParent.children!.append(nodeToMove)
        return FlowContinuation.proceed
    }
    
    func enterChildDir() -> FlowContinuation {
        if element==LB_ROOT {
            stack=[]
            stack.append(currentNode)
            return FlowContinuation.skip
        }
        
        if (currentNode.children!.filter { $0.name == element && $0.content == nil }.count>0) {
            currentNode=nodesGlobal.filter { $0.name == element && $0.content == nil }.first!
            stack.append(currentNode)
            return FlowContinuation.skip
        }
        
        if (nodesGlobal.filter { $0.name == element && $0.content == nil }.count>0) {
            print("refusing to add duplicate folder"+element)
            return FlowContinuation.skip
        }
        let folderNode:TreeNode=TreeNode(content: nil, name: String(element), parent: currentNode)
        currentNode.children!.append(folderNode)
        stack.append(folderNode)
        currentNode = folderNode
        context.insert(folderNode)// why not adding to nodes global
        // TODO: append this node to file of all tagfolder names
        return FlowContinuation.proceed
    }
    
    func commit(_ serialisedTree:String)  {
        if(!persistCommitChangeToFile(serialisedTree)){
            decreaseCommitVersion()
        }
    }
    
    func persistCommitChangeToFile(_ serialisedTree:String) -> Bool {
        do {
            try createHistoryIfNotExist()
            let newVersion=UserDefaults.standard.integer(forKey: UD_VERSION_NUMBER)+1
            UserDefaults.standard.set(newVersion, forKey: UD_VERSION_NUMBER)
            let fileName=String(newVersion)
            try writeToFile(input: serialisedTree, path: DIR_HISTORY+"/"+fileName+".txt")
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    func decreaseCommitVersion()  {
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: UD_VERSION_NUMBER)-1, forKey: UD_VERSION_NUMBER)
    }
    
    func isFolder(_ node: TreeNode) -> Bool {
        return node.content == nil
    }
}
