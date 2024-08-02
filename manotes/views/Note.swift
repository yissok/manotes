import SwiftUI
import SwiftData

struct Note: View {
    @EnvironmentObject var contextProvider: ContextProvider
    var nodesGlobal:[TreeNode]
    let item: TreeNode
    @Binding var showPanel:Bool
    @Binding var ovelayAction:OverlayAction
    @Binding var selectedNode:TreeNode?
    
    
    var body: some View {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "d MMM yy"
        formatterDate.timeZone = TimeZone.current
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH:mm:ss"
        formatterTime.timeZone = TimeZone.current
        return HStack{
            VStack(alignment: .trailing) {
                Text(formatterDate.string(from: Date(timeIntervalSince1970: Double(item.name)! / 1000.0)))
                    .bold()
                Text(formatterTime.string(from: Date(timeIntervalSince1970: Double(item.name)! / 1000.0)))
                    .bold()
            }
            .padding(.leading, -10)
            .padding(.trailing, 5)
            Text(item.enc ?
                     item.content ?? "no_content" :
                    (item.content?.base64Decoded ?? "no_content")!
            )
            Spacer()
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        .contextMenu {
            Button(action: {
                
            }) {
                Label("Edit", systemImage: "pencil")
            }
            Button(action: {
                callShortcutWith(item.content ?? "no_content")
            }) {
                Label("View", systemImage: "eye")
            }
            Button(action: {
                
            }) {
                Label("Copy", systemImage: "doc.on.doc")
            }
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
