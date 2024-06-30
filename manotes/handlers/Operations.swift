import Foundation
import SwiftData



func addTagViaSerial(_ itemTag: String, _ name: String, _ content: String?,_ parent: String, _ context: ModelContext) {
    print("adding tag")
}
func addTag(_ itemTag: String,_ parent: TreeNode?, _ context: ModelContext) {
    print("adding tag")
    let item = TreeNode(content:nil, name: itemTag, parent: parent)
    if (item.parent != nil){
        item.parent?.children.append(item)
        context.insert(item.parent!)
        context.insert(item)
    } else {
        context.insert(item)
    }
}
func addNoteViaSerial(_ itemTag: String, _ name: String?, _ content: String, _ parent: String, _ context: ModelContext) {
    print("adding note")
}
func addNote(_ itemTag: String, _ itemValue: String, _ context: ModelContext,_ tags: [TreeNode]) {
    print("adding note")
    let existingTag = tags.filter { $0.name.caseInsensitiveCompare(itemTag) == .orderedSame }.first ?? nil
    let newNote = TreeNode(content: itemValue, name:itemTag,parent: existingTag)
    
    if (existingTag != nil){
        existingTag!.children.append(newNote)
        context.insert(existingTag!)
    } else {
        context.insert(newNote)
    }
}

func deleteTag(_ item: TreeNode, _ context: ModelContext) {
    item.children.forEach { child in
        deleteTag(child, context)
    }
    if (item.content==nil) {
        print("deleteTagFolder: "+item.name)
    } else {
        print("deleteNote: "+(item.content ?? "n/a"))
    }
    removeChildReference(item, context)
    context.delete(item)
}

func deleteItem(_ item: TreeNode, _ context: ModelContext) {
    print("delete note")
    removeChildReference(item, context)
    context.delete(item)
}

func removeChildReference(_ item: TreeNode, _ context: ModelContext) {
    print("delete ref")
    if let index = item.parent?.children.firstIndex(of: item) {
        item.parent?.children.remove(at: index)
        try! context.save()
    }
    context.delete(item)
}
