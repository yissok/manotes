
import Foundation
import SwiftUI

func callShortcutWith(_ itemValue: String) {
    print("calling shortcut")
    let shortcut = URL(string: shtctcall+itemValue)!
    UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
}

func onSheetDismissed(_ nodesGlobal: [TreeNode], _ contextProvider: ContextProvider, _ note: TreeNode, _ noteText: String) {
    // TODO: save noteText
    note.content=noteText.base64Encoded
    contextProvider.context?.insert(note)
    print("The sheet was dismissed")
    if let index = nodesGlobal.firstIndex(where: { $0.content == "" }) {
        print("Index content to delete: \(nodesGlobal[index].content)")
        handleDeletionInput(nodesGlobal[index].name, nodesGlobal,contextProvider.context!)
    } else {
        print("No element found with content == \"\"")
    }
}


func move(_ filteredNodes:[TreeNode], parent: TreeNode, from sources: IndexSet, to destination: Int) {
    for source in sources {
        let destFromZero = source>destination ? destination : destination-1
        print("parent \(parent.name)")
        print("src \(source)")
        print("destination \(destFromZero)")
        print("")
        parent.children!.filter { $0.content != nil && $0.orderUnderParent > source }.forEach { node in
            node.orderUnderParent -= 1
        }
        
        parent.children!.filter { $0.content != nil && $0.orderUnderParent >= destFromZero }.forEach { node in
            node.orderUnderParent += 1
        }
        filteredNodes[source].orderUnderParent=destFromZero
    }
}
func deleteAt(_ filteredNodes:[TreeNode], _ indexes:IndexSet,_ nodesGlobal: [TreeNode], _ contextProvider: ContextProvider) {
    for index in indexes {
        if let globalIndex = nodesGlobal.firstIndex(of: filteredNodes[index]) {
            handleDeletionInput(nodesGlobal[globalIndex].name, nodesGlobal,contextProvider.context!)
        }
    }
}
