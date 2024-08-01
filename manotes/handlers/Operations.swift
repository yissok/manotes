import Foundation
import SwiftData



func generateSerialTree(_ parent: String,_ tags: [TreeNode], _ name: String?, _ content: String?, _ context: ModelContext) -> String {
    let lowCParent=parent.lowercased()
    let parentTag = tags.filter { $0.name.caseInsensitiveCompare(lowCParent) == .orderedSame }.first ?? nil
    let tree=parentChain(parentTag)+addNoteOrTagOrExcl(content, name, parentTag?.name)
    print("executing: "+tree)
    return tree
}
func generateSerialTreeForMoving(_ toMove: String, _ destination: String,_ tags: [TreeNode], _ context: ModelContext, isNote: Bool) -> String {
    let lowCDestination=destination.lowercased()
    print("generateSerialTreeForMoving")
    var toMoveNode = tags.filter { $0.name == toMove }.first!
    let toMoveNodeChain=parentChain(toMoveNode)+"<>"
    let backToRootChain = getChainToGetBackToRoot(toMoveNodeChain)
    var destNode =  tags.filter { $0.name == lowCDestination }.first ?? TreeNode(content: "", name: "", parent: nil)
    if destNode.name == "" {
        return ""
    }
    let destNodeChain = parentChain(destNode).replacingOccurrences(of: LB_ROOT+"-", with: "")+"<>"+getChainToGetBackToRoot(parentChain(isNote ? destNode.parent : destNode))
    print("generateSerialTreeForMoving: "+toMoveNodeChain+backToRootChain+destNodeChain)
    return toMoveNodeChain+backToRootChain+destNodeChain
}

func generateSerialTreeForBulkMoving(_ destination: String,_ tags: [TreeNode], _ context: ModelContext, _ selectedNodes:Set<TreeNode>) -> [String] {
    var multiMove:[String]=[]
    selectedNodes.forEach { toMoveItem in
        multiMove.append(generateSerialTreeForMoving(toMoveItem.name, destination, tags, context, isNote: toMoveItem.content != nil))
    }
    return multiMove
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
        return LB_ROOT
    }
    return parentChain(parentTag!.parent!)+"-"+parentTag!.name
}

func addNoteOrTagOrExcl(_ content: String?, _ name: String?, _ parentTag: String?) -> String {
    var tmpContent = content
    var isEncrypted = false
    if tmpContent != nil {
        if tmpContent!.starts(with: NOENC_LABEL) {
            tmpContent=tmpContent!.replacingOccurrences(of: NOENC_LABEL, with: "")
            if parentTag != nil {
                tmpContent = tmpContent!.decodeUrl().base64Decoded?.components(separatedBy: " ").dropFirst().joined(separator: " ").base64Encoded?.encodeUrl()
            }
        } else if tmpContent!.starts(with: YESENC_LABEL){
            tmpContent=tmpContent!.replacingOccurrences(of: YESENC_LABEL, with: "")
            isEncrypted=true
        }
    }
    return tmpContent==nil ? (name==nil ? "!" : "-"+name!) : "-"+NOTE_DELIMITER+(isEncrypted ? "@" : "")+tmpContent!
}

func deleteTag(_ item: TreeNode, _ context: ModelContext) {
    item.children!.forEach { child in
//        if child.name=="bb" || child.name=="bchild" {
//            return        }
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
    print("delete ref from \(item.name)'s parent")
    if let index = item.parent?.children!.firstIndex(of: item) {
        item.parent?.children!.remove(at: index)
        try! context.save()
    }
    context.delete(item)
}
