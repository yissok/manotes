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
            Button{
                withAnimation {
                    showPanel.toggle()
                    ovelayAction=OverlayAction.moveNode
                    selectedNode=item
                }
            } label: {
                Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
            }
            .foregroundColor(Color.yellow)
            .buttonStyle(PlainButtonStyle())
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        
    }
}

