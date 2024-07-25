import SwiftUI
import SwiftData

struct Tag: View {
    @EnvironmentObject var contextProvider: ContextProvider
    var nodesGlobal:[TreeNode]
    let item: TreeNode
    @Binding var showPanel:Bool
    @Binding var ovelayAction:OverlayAction
    @Binding var selectedNode:TreeNode?
    
    var body: some View {
        return HStack{
            NavigationLink(item.name) {
                ItemList(nodesGlobal: nodesGlobal, parent: item)
            }
            Spacer()
            MoveBtn(item: item, showPanel: $showPanel, ovelayAction: $ovelayAction, selectedNode: $selectedNode)
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        
    }
}

