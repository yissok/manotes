
import SwiftUI

struct MoveBtn: View {
    let item: TreeNode
    @Binding var showPanel:Bool
    @Binding var ovelayAction:OverlayAction
    @Binding var selectedNode:TreeNode?
    var body: some View {
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
}
