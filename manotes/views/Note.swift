import SwiftUI
import SwiftData

struct Note: View {
    @EnvironmentObject var contextProvider: ContextProvider
    let item: TreeNode
    
    
    var body: some View {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "d MMM yy"
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH:mm:ss"
        return HStack{
            VStack(alignment: .trailing) {
                Text(formatterDate.string(from: Date(timeIntervalSince1970: Double(item.name)! / 1000.0)))
                    .font(.custom("Courier", size: 12))
                    .bold()
                Text(formatterTime.string(from: Date(timeIntervalSince1970: Double(item.name)! / 1000.0)))
                    .font(.custom("Courier", size: 12))
                    .bold()
            }
            .padding(.leading, -10)
            .padding(.trailing, 5)
            if item.enc{
                Text(item.content ?? "no_content")
                    .font(.custom("Courier", size: 12))
            } else
            {
                Text(((item.content?.base64Decoded?.replacingOccurrences(of: item.parent!.name+" ", with: "") ?? "no_content")!))
                    .font(.custom("Courier", size: 12))
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

//#Preview {
//    Note(item: TreeNode(content: "aa", name: "1721726280", parent: nil))
//}

