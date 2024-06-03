import SwiftUI
import SwiftData

struct RootItem: View {
    @EnvironmentObject var contextProvider: ContextProvider
    @State private var content:String = ""
    let item: Entry
    
    var shtctcall = "shortcuts://run-shortcut?name="+SHORTCUT_NAME+"&input="
    
    var body: some View {
        return HStack{
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
        
        func callShortcutWith(_ itemValue: String) {
            print("calling shortcut")
            let shortcut = URL(string: shtctcall+itemValue)!
            UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
        }
        
    }
}

