import SwiftUI
import SwiftData

struct RootNote: View {
    @EnvironmentObject var contextProvider: ContextProvider
    let item: TreeNode
    
    
    var body: some View {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "d MMM HH:mm:ss"
        return HStack{
//            Text(item.parent == nil ? "currentViewParentTag" : item.parent!.name).bold()
            Text(formatter3.string(from: (Date(timeIntervalSince1970: (Double(item.name)! / 1000.0))))).bold()

            Text(item.content ?? "no_content")
            Spacer()
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

