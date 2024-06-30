import Foundation
import SwiftData

@Model
class TreeNode: Identifiable {
    var id: String
    var name: String
    var content: String?
    var children: [TreeNode] = []
    var parent: TreeNode?
    
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
            for child in node.children.sorted(by: { $0.name < $1.name }) {
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
        var stack: [TreeNode]=[]
        for element in elements {
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
                print("does not support node removals")
                return []
            } else if element.contains(":") {
                let note = unwrapNote(noteStr: String(element))
                let noteNode = TreeNode(content: note.content, name: note.name, parent: currentNode)
                currentNode.children.append(noteNode)
                context.insert(noteNode)
            } else {
                
                if element==LB_ROOT {
                    stack=[]
                    stack.append(currentNode)
                    continue
                }
                
                if (currentNode.children.filter { $0.name == element && $0.content == nil }.count>0) {
                    currentNode=nodesGlobal.filter { $0.name == element && $0.content == nil }.first!
                    stack.append(currentNode)
                    continue
                }
                let folderNode:TreeNode=TreeNode(content: nil, name: String(element), parent: currentNode)
                currentNode.children.append(folderNode)
                
                if (nodesGlobal.filter { $0.name == element && $0.content == nil }.count>0) {
                    print("refusing to add duplicate folder"+element)
                    return []
                }
                stack.append(folderNode)
                currentNode = folderNode
                context.insert(folderNode)
            }
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
        return nodesGlobal
    }
    
    static func isFolder(_ node: TreeNode) -> Bool {
        return node.content == nil
    }
}
