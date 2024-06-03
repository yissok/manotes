import SwiftUI
import SwiftData

struct RootNote: View {
    @EnvironmentObject var contextProvider: ContextProvider
    let item: Note2
    
    var shtctcall = "shortcuts://run-shortcut?name="+SHORTCUT_NAME+"&input="
    
    var body: some View {
        return HStack{
            Text(item.tag).bold()
            Text(item.name)
            Spacer()
            Button{
                callShortcutWith(item.name)
            } label: {
                Image(systemName: "pencil")
            }
            .foregroundColor(Color.blue)
            .buttonStyle(PlainButtonStyle())
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        
        func callShortcutWith(_ itemValue: String) {
            print("calling shortcut")
            let shortcut = URL(string: shtctcall+itemValue)!
            UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
        }
        
    }
}

