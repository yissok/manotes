import Foundation
import SwiftData



func addTag(_ itemTag: String,_ parent: TreeNode?, _ context: ModelContext) {
    print("adding tag")
    let item = TreeNode(content:nil, name: itemTag, parent: parent)
    if (item.parent != nil){
        item.parent?.children.append(item)
        context.insert(item.parent!)
    } else {
        context.insert(item)
    }
}

func addNote(_ itemTag: String, _ itemValue: String, _ context: ModelContext,_ tags: [TreeNode]) {
    print("adding note")
    var existingTag = tags.filter { $0.name.elementsEqual(itemTag) }.first ?? nil
    let newNote = TreeNode(content: itemValue, name:itemTag,parent: existingTag)
    
    if (existingTag != nil){
        existingTag!.children.append(newNote)
        context.insert(existingTag!)
    } else {
        context.insert(newNote)
    }
}

func deleteTag(_ item: TreeNode, _ context: ModelContext) {
    print("deleting note")
    context.delete(item)
}

func deleteItem(_ item: TreeNode, _ context: ModelContext) {
    print("deleting note")
    context.delete(item)
}
