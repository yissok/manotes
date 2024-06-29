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
    
    
    static func deserialise(_ serialisedTree: String, context: ModelContext) -> TreeNode {
        let rootNode = TreeNode(content: nil, name: "ROOT", parent: nil)
        context.insert(rootNode)
        var currentNode = rootNode
        var stack: [TreeNode] = [rootNode]
        
        let elements = serialisedTree.split(separator: "-")
        for element in elements {
            if element == "_" {
                stack.removeLast()
                if let parent = stack.last {
                    currentNode = parent
                }
            } else if element.contains(":") {
                let note = element.split(separator: ":")
                let noteName = String(note[0])
                let noteContent = String(note[1])
                let noteNode = TreeNode(content: noteContent, name: noteName, parent: currentNode)
                currentNode.children.append(noteNode)
                context.insert(noteNode)
            } else {
                let folderNode = TreeNode(content: nil, name: String(element), parent: currentNode)
                currentNode.children.append(folderNode)
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
        return rootNode
    }
    
    static func isFolder(_ node: TreeNode) -> Bool {
        return node.content == nil
    }
}
