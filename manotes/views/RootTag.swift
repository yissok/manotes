import SwiftUI
import SwiftData

struct RootTag: View {
    @EnvironmentObject var contextProvider: ContextProvider
    var nodesGlobal:[TreeNode]
    let item: TreeNode
    @Binding var showPanel:Bool
    @Binding var zSwap:Bool
    @FocusState.Binding var isNewFolderNameFocused: Bool
    @Binding var ovelayAction:OverlayAction
    @Binding var selectedNode:TreeNode?
    
    var body: some View {
        return HStack{
//            Text(item.parent == nil ? "r" : item.parent!.name).bold()
            NavigationLink(item.name) {
                ItemList(nodesGlobal: nodesGlobal, parent: item)
            }
            Spacer()
            Button{
                
                withAnimation {
                    showPanel.toggle()
                    zSwap.toggle()
                    isNewFolderNameFocused=true
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

