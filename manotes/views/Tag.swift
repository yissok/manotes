import SwiftUI
import SwiftData

struct Tag: View {
    @EnvironmentObject var contextProvider: ContextProvider
    var nodesGlobal:[TreeNode]
    let item: TreeNode
    @Binding var showPanel:Bool
    @Binding var ovelayAction:OverlayAction
    @Binding var selectedNode:TreeNode?
    @State private var isActive: Bool = false
    
    var body: some View {
        return HStack{
            Text(item.name)
            NavigationLink(destination: ItemList(nodesGlobal: nodesGlobal, parent: item)) {}
            Spacer()
            MoveBtn(item: item, showPanel: $showPanel, ovelayAction: $ovelayAction, selectedNode: $selectedNode)
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        
    }
}

