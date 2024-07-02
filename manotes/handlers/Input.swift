import Foundation
import SwiftData


func handleNewTagInput(_ currentTag: String,_ tags: [TreeNode], _ name: String, _ context: ModelContext) {
    let serial = generateSerialTree(currentTag, tags, name, nil, context)
    TreeNode.insertTree(serial, tags, context: context)
}

func handleNewNoteInput(_ currentTag: String,_ tags: [TreeNode], _ content: String, _ context: ModelContext) {
    let serial = generateSerialTree(currentTag, tags, nil, content, context)
    TreeNode.insertTree(serial, tags, context: context)
}

func handleShortcutInput(_ url: URL,_ tags: [TreeNode], _ context: ModelContext) {
    let input = url.queryParameters![INPUT_LABEL]!.components(separatedBy:"_")
    let serial = generateSerialTree( input[0], tags, nil, input[1], context)
    TreeNode.insertTree(serial, tags, context: context)
    switch url.host() {
    case nil:
        print("generic host")
    default:
        print("other host")
        break
    }
}
