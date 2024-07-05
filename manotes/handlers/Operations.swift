import Foundation
import SwiftData



func generateSerialTree(_ parent: String,_ tags: [TreeNode], _ name: String?, _ content: String?, _ context: ModelContext) -> String {
    print("adding tag")
    let parentTag = tags.filter { $0.name.caseInsensitiveCompare(parent) == .orderedSame }.first ?? nil
    let tree=parentChain(parentTag)+addNoteOrTagOrExcl(content, name)
    print("executing: "+tree)
    return tree
}

func parentChain(_ parentTag: TreeNode?) -> String {
    if parentTag==nil || parentTag!.parent==nil {
        return "ROOT"
    }
    return parentChain(parentTag!.parent!)+"-"+parentTag!.name
}

func addNoteOrTagOrExcl(_ content: String?, _ name: String?) -> String {
    return content==nil ? (name==nil ? "!" : "-"+name!) : "-"+SERIAL_CONTENT_SEPARATOR+content!
}

func deleteTag(_ item: TreeNode, _ context: ModelContext) {
    item.children!.forEach { child in
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
    if let index = item.parent?.children!.firstIndex(of: item) {
        item.parent?.children!.remove(at: index)
        try! context.save()
    }
    context.delete(item)
}
