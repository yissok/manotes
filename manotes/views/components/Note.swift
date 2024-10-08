import SwiftUI
import SwiftData

struct Note: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var contextProvider: ContextProvider
    var nodesGlobal:[TreeNode]
    let item: TreeNode
    @Binding var showPanel:Bool
    @Binding var ovelayAction:OverlayAction
    @Binding var selectedNode:TreeNode?
    var index:Int
    
    @State private var dynamicHeight: CGFloat = .zero
    @State private var showingNewNoteSheet = false
    @Binding var noteText:String
    
    var body: some View {
//        let formatterDate = DateFormatter()
//        formatterDate.dateFormat = "d MMM yy"
//        formatterDate.timeZone = TimeZone.current
//        let formatterTime = DateFormatter()
//        formatterTime.dateFormat = "HH:mm:ss"
//        formatterTime.timeZone = TimeZone.current
//        let dayDate = formatterDate.string(from: Date(timeIntervalSince1970: Double(item.name)! / 1000.0))
//        let hourDate = formatterTime.string(from: Date(timeIntervalSince1970: Double(item.name)! / 1000.0))
        return HStack{
//            VStack(alignment: .trailing) {
//                Text(dayDate)
//                    .bold()
//                Text(hourDate)
//                    .bold()
//            }
//            .padding(.leading, -10)
//            .padding(.trailing, 5)
//            Text(String(item.orderUnderParent))
            Text(item.enc ?
                     item.content ?? "no_content" :
                    (item.content?.base64Decoded ?? "no_content")!
            )
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .sheet(isPresented: $showingNewNoteSheet) {
                NoteView(note: item, isNew: false, noteT: $noteText)
            }
            .onChange(of: showingNewNoteSheet, {
                if !showingNewNoteSheet {
                    onSheetDismissed(nodesGlobal, contextProvider, item, noteText)
                }
            })
            if item.enc{
                Label("", systemImage: "lock")
                    .foregroundColor(Color.yellow)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(getColRow().opacity(0.8))
        .onTapGesture {
            if item.enc {
                callShortcutWith(item.content ?? "no_content")
            } else {
                noteText = item.content!.base64Decoded ?? item.content!
                showingNewNoteSheet.toggle()
            }
        }
        .listRowBackground(getColRow())
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
    
    
    func getColRow() -> Color {
        return colorScheme == .dark ? Color.black : Color.white
    }
//    func getColRow() -> Color { //brown
//        return colorScheme == .dark ?
//            (index % 2 == 0 ?   Color(red: 96/255, green: 72/255, blue: 31/255) :
//                                Color(red: 58/255, green: 43/255, blue: 19/255)) :
//            (index % 2 == 0 ?   Color(red: 211/255, green: 178/255, blue: 120/255) :
//                                Color(red: 224/255, green: 199/255, blue: 158/255))
//    }
}
