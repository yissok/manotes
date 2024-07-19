import Foundation
import SwiftData


func handleNewTagInput(_ currentTag: String,_ tags: [TreeNode], _ name: String, _ context: ModelContext, _ ovelayAction: OverlayAction) {
    switch ovelayAction {
    case OverlayAction.newFolder:
        let serial = generateSerialTree(currentTag, tags, name, nil, context)
        TreeNode.insertTree(serial, tags, context: context)
    case OverlayAction.moveNode:
        let serial = generateSerialTreeForMoving(currentTag, name, tags, context)
        TreeNode.insertTree(serial, tags, context: context)
    default:
        print("refusing to generate tree input")
    }
    
}

func handleNewNoteInput(_ currentTag: String,_ tags: [TreeNode], _ content: String, _ context: ModelContext) {
    let serial = generateSerialTree(currentTag, tags, nil, content, context)
    TreeNode.insertTree(serial, tags, context: context)
}

func handleDeletionInput(_ currentTag: String,_ tags: [TreeNode], _ context: ModelContext) {
    let serial = generateSerialTree(currentTag, tags, nil, nil, context)
    TreeNode.insertTree(serial, tags, context: context)
}

func handleShortcutInput(_ encStr: String,_ tags: [TreeNode], _ context: ModelContext) {
    let input = encStr.components(separatedBy:"_")
    let serial = generateSerialTree( input[0], tags, nil, input[1], context)
    TreeNode.insertTree(serial, tags, context: context)
}
