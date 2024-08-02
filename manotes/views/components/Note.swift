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
        let dayDate = formatterDate.string(from: Date(timeIntervalSince1970: Double(item.name)! / 1000.0))
        let hourDate = formatterTime.string(from: Date(timeIntervalSince1970: Double(item.name)! / 1000.0))
        return HStack{
            VStack(alignment: .trailing) {
                Text(dayDate)
                    .bold()
                Text(hourDate)
                    .bold()
            }
            .padding(.leading, -10)
            .padding(.trailing, 5)
            Text(item.enc ?
                     item.content ?? "no_content" :
                    (item.content?.base64Decoded ?? "no_content")!
            )
            if item.enc{
                Label("", systemImage: "lock")
                    .foregroundColor(Color.yellow)
            }
            Spacer()
            NavigationLink(destination: NoteView(note: item, dayDate: dayDate, hourDate: hourDate)) { EmptyView()}
                .frame(width: 0.5, height: 0,  alignment: .trailing)
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
