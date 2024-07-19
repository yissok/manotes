import Foundation
import SwiftData



func generateSerialTree(_ parent: String,_ tags: [TreeNode], _ name: String?, _ content: String?, _ context: ModelContext) -> String {
    print("adding tag")
    let parentTag = tags.filter { $0.name.caseInsensitiveCompare(parent) == .orderedSame }.first ?? nil
    let tree=parentChain(parentTag)+addNoteOrTagOrExcl(content, name)
    print("executing: "+tree)
    return tree
}
func generateSerialTreeForMoving(_ toMove: String, _ destination: String,_ tags: [TreeNode], _ context: ModelContext) -> String {
    print("generateSerialTreeForMoving")
    var toMoveNode = tags.filter { $0.name == toMove && $0.content == nil }.first!
    let toMoveNodeChain=parentChain(toMoveNode)+"<>"
    let backToRootChain = getChainToGetBackToRoot(toMoveNodeChain)
    var destNode = tags.filter { $0.name == destination && $0.content == nil }.first!
    let destNodeChain=parentChain(destNode).replacingOccurrences(of: "ROOT-", with: "")+"<>"
    print("generateSerialTreeForMoving: "+toMoveNodeChain+backToRootChain+destNodeChain)
    return toMoveNodeChain+backToRootChain+destNodeChain
}

func getChainToGetBackToRoot(_ chain: String) -> String {
    var res = ""
    for _ in 0..<chain.numberOfOccurrencesOf(string: "-") {
        res += "-_"
    }
    res += "-"
    return res
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


func moveChildrenToNewParent(_ old: TreeNode, _ new: TreeNode, _ context: ModelContext) {
    old.children!.forEach { child in
        child.parent=new
    }
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
