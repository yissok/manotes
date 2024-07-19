import Foundation
import SwiftData

@Model
class TreeNode: Identifiable {
    var id: String=""
    var name: String=""
    var content: String?=nil
    var children: [TreeNode]? = []
    var parent: TreeNode?=nil
    
    @Relationship(inverse: \TreeNode.parent) var childrenINVERSE: [TreeNode]?
    @Relationship(inverse: \TreeNode.children) var parentINVERSE: TreeNode?
    
    init(content: String?, name: String, parent:TreeNode?) {
        self.id = UUID().uuidString
        self.content = content
        self.name = name
        self.parent = parent
        children = []
    }
    
    static func serialise(_ node:TreeNode) -> String{
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
    
    
    static func insertTree(_ serialisedTree: String, _ nodesGlobal:[TreeNode], context: ModelContext) -> [TreeNode] {
        
        var elements = serialisedTree.split(separator: "-")
        var currentNode:TreeNode=nodesGlobal.filter { $0.name == LB_ROOT }.first!
        var nodeToMove:TreeNode=TreeNode(content: "", name: "", parent: nil)
        var movingNode=false
        var stack: [TreeNode]=[]
        for elementSub in elements {
            let element = String(elementSub)
            if element == "_" {
                if stack.count==0 {
                    print("malformed tree, going above root level")
                    return []
                }
                stack.removeLast()
                if let parent = stack.last {
                    currentNode = parent
                }
            } else if element.contains("!") {
                let matching = nodesGlobal.filter { $0.name == element.dropLast() }
                if matching.count==0 {
                    continue
                }
                deleteTag(matching.first!, context)
            } else if element.contains(":") {
                let note = unwrapNote(noteStr: String(element))
                let noteNode = TreeNode(content: note.content, name: note.name, parent: currentNode)
                currentNode.children!.append(noteNode)
                context.insert(noteNode)
            }
             else if element.contains("<>") {
                 let moveEl = element.replacingOccurrences(of: "<>", with: "")
                 if(!movingNode) {
                     movingNode=true
                     currentNode=nodesGlobal.filter { $0.name == moveEl && $0.content == nil }.first!
                     nodeToMove=currentNode
                     continue
                 }
                 var newParent = nodesGlobal.filter { $0.name == moveEl && $0.content == nil }.first!
                 nodeToMove.parent=newParent
                 newParent.children!.append(nodeToMove)
            } else {
                
                if element==LB_ROOT {
                    stack=[]
                    stack.append(currentNode)
                    continue
                }
                
                if (currentNode.children!.filter { $0.name == element && $0.content == nil }.count>0) {
                    currentNode=nodesGlobal.filter { $0.name == element && $0.content == nil }.first!
                    stack.append(currentNode)
                    continue
                }
                
                if (nodesGlobal.filter { $0.name == element && $0.content == nil }.count>0) {
                    print("refusing to add duplicate folder"+element)
                    continue
                }
                let folderNode:TreeNode=TreeNode(content: nil, name: String(element), parent: currentNode)
                currentNode.children!.append(folderNode)
                stack.append(folderNode)
                currentNode = folderNode
                context.insert(folderNode)
            }
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
                return []
            }
        }
        commit(serialisedTree)
        return nodesGlobal
    }
    
    static func commit(_ serialisedTree:String)  {
        if(persistCommitChangeToFile(serialisedTree)){
            incrementCommitVersion()
        }
        
    }
    
    static func persistCommitChangeToFile(_ serialisedTree:String) -> Bool {
        do {
            try createHistoryIfNotExist()
            let fileName=String(UserDefaults.standard.integer(forKey: UD_VERSION_NUMBER))
            try writeToFile(input: serialisedTree, path: DIR_HISTORY+"/"+fileName+".txt")
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func incrementCommitVersion()  {
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: UD_VERSION_NUMBER)+1, forKey: UD_VERSION_NUMBER)
    }
    
    static func isFolder(_ node: TreeNode) -> Bool {
        return node.content == nil
    }
}
