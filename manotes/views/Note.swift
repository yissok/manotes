import SwiftUI
import SwiftData

struct Note: View {
    @EnvironmentObject var contextProvider: ContextProvider
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
        print(TimeZone.current.abbreviation())
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
                     (item.content?.base64Decoded?.replacingOccurrences(of: item.parent!.name+" ", with: "") ?? "no_content")!
            )
            Spacer()
            MoveBtn(item: item, showPanel: $showPanel, ovelayAction: $ovelayAction, selectedNode: $selectedNode)
            Button{
                callShortcutWith(item.content ?? "no_content")
            } label: {
                Image(systemName: "pencil")
            }
            .foregroundColor(Color.yellow)
            .buttonStyle(PlainButtonStyle())
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        
        
    }
}
