import SwiftUI
import SwiftData

struct Note: View {
    @EnvironmentObject var contextProvider: ContextProvider
    let item: TreeNode
    
    
    var body: some View {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "d MMM HH:mm:ss"
        return HStack{
            Text(formatter3.string(from: (Date(timeIntervalSince1970: (Double(item.name)! / 1000.0))))).bold()
            if item.enc{
                Text(item.content ?? "no_content")
            } else
            {
                Text(((item.content?.base64Decoded?.replacingOccurrences(of: item.parent!.name+" ", with: "") ?? "no_content")!))
            }
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

