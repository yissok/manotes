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
        var currentNode:TreeNode?
        let existingTags=nodesGlobal.filter { $0.name == elements[0] && $0.content == nil }
        if existingTags.count==1 {
            currentNode = existingTags.first!
            elements.removeFirst()
        } else {
            print(existingTags.count)
            currentNode=nil
        }
        var stack: [TreeNode]=[]
        for element in elements {
            if element == "ROOT" {
                continue
            }
            if element == "_" {
                stack.removeLast()
                if let parent = stack.last {
                    currentNode = parent
                }
            } else if element.contains(":") {
                let note = element.split(separator: ":")
                let noteName = note.count==1 ? String(Int(Date().timeIntervalSince1970.truncate(places: 3)*1000)) : String(note[0])
                let noteContent = note.count==1 ? String(note[0]) : String(note[1])
                let noteNode = TreeNode(content: noteContent, name: noteName, parent: currentNode)
                if (currentNode != nil){
                    currentNode!.children.append(noteNode)
                }
                context.insert(noteNode)
            } else {
                let folderNode:TreeNode?
                if (currentNode != nil){
                    if (currentNode!.children.filter { $0.name == element && $0.content == nil }.count>0) {
                        currentNode=nodesGlobal.filter { $0.name == element && $0.content == nil }.first!
                        stack.append(currentNode!)
                        continue
                    }
                    folderNode=TreeNode(content: nil, name: String(element), parent: currentNode)
                    currentNode!.children.append(folderNode!)
                } else{
                    folderNode=TreeNode(content: nil, name: String(element), parent: currentNode)
                }
                
                if (nodesGlobal.filter { $0.name == element && $0.content == nil }.count>0) {
                    print("refusing to add duplicate folder"+element)
                    return []
                }
                stack.append(folderNode!)
                currentNode = folderNode
                context.insert(folderNode!)
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
