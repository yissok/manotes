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
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        .contextMenu {
                Button(action: {
                    showPanel.toggle()
                    ovelayAction=OverlayAction.moveNode
                    selectedNode=item
                }) {
                    Label("Move", systemImage: "arrow.up.and.down.and.arrow.left.and.right")
                }
                Button(role: .destructive, action: {
                    handleDeletionInput(item.name, nodesGlobal,contextProvider.context!)
                }) {
                    Label("Delete", systemImage: "trash")
                }
        }
        
    }
}

