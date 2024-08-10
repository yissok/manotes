import Foundation
import SwiftData


func handleNewTagInput(_ currentTag: String,_ tags: [TreeNode], _ name: String, _ context: ModelContext, _ ovelayAction: OverlayAction, _ selectedNodes:Set<TreeNode>) {
    let lowCName=name.lowercased()
    switch ovelayAction {
        case OverlayAction.newFolder:
            let serial = generateSerialTree(currentTag, tags, lowCName, nil, context)
            TreeNodeSerial(nodesGlobal: tags, context: context).insertTree(serial)
        case OverlayAction.moveNode:
            let serial = generateSerialTreeForMoving(currentTag, lowCName, tags, context, isNote: tags.filter { $0.name == currentTag }.first!.content != nil)
            TreeNodeSerial(nodesGlobal: tags, context: context).insertTree(serial)
        case OverlayAction.bulkMove:
            let serials:[String] = generateSerialTreeForBulkMoving(lowCName, tags, context, selectedNodes)
            serials.forEach { serial in
                TreeNodeSerial(nodesGlobal: tags, context: context).insertTree(serial)
            }
        default:
            print("refusing to generate tree input")
    }
    
}

func handleNewNoteInput(_ currentTag: String,_ tags: [TreeNode], _ content: String, _ context: ModelContext) -> TreeNode {
    let serial = generateSerialTree(currentTag, tags, nil, content, context)
    return TreeNodeSerial(nodesGlobal: tags, context: context).insertTree(serial)
}

func handleDeletionInput(_ currentTag: String,_ tags: [TreeNode], _ context: ModelContext) {
    let serial = generateSerialTree(currentTag, tags, nil, nil, context)
    TreeNodeSerial(nodesGlobal: tags, context: context).insertTree(serial)
}

func handleShortcutInput(_ encStr: String,_ tags: [TreeNode], _ context: ModelContext, noteDate:String) {
    let input = encStr.components(separatedBy:"_")
    if input.count<3 {
        return
    }
    let serial = generateSerialTree( input[1], tags, nil, input[0]+"_"+input[2], context)
    TreeNodeSerial(nodesGlobal: tags, context: context, noteDate:noteDate).insertTree(serial)
}
