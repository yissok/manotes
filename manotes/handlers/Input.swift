import Foundation
import SwiftData


func handleNewTagInput(_ currentTag: String,_ tags: [TreeNode], _ name: String, _ context: ModelContext, _ ovelayAction: OverlayAction) {
    let lowCName=name.lowercased()
    switch ovelayAction {
        case OverlayAction.newFolder:
            let serial = generateSerialTree(currentTag, tags, lowCName, nil, context)
            TreeNodeSerial(nodesGlobal: tags, context: context).insertTree(serial, tags, context: context)
        case OverlayAction.moveNode:
            let serial = generateSerialTreeForMoving(currentTag, lowCName, tags, context)
            TreeNodeSerial(nodesGlobal: tags, context: context).insertTree(serial, tags, context: context)
        default:
            print("refusing to generate tree input")
    }
    
}

func handleNewNoteInput(_ currentTag: String,_ tags: [TreeNode], _ content: String, _ context: ModelContext) {
    let serial = generateSerialTree(currentTag, tags, nil, content, context)
    TreeNodeSerial(nodesGlobal: tags, context: context).insertTree(serial, tags, context: context)
}

func handleDeletionInput(_ currentTag: String,_ tags: [TreeNode], _ context: ModelContext) {
    let serial = generateSerialTree(currentTag, tags, nil, nil, context)
    TreeNodeSerial(nodesGlobal: tags, context: context).insertTree(serial, tags, context: context)
}

func handleShortcutInput(_ encStr: String,_ tags: [TreeNode], _ context: ModelContext) {
    let input = encStr.components(separatedBy:"_")
    if input.count<3 {
        return
    }
    let serial = generateSerialTree( input[1], tags, nil, input[0]+"_"+input[2], context)
    TreeNodeSerial(nodesGlobal: tags, context: context).insertTree(serial, tags, context: context)
}
