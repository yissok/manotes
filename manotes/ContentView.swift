import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context;
    @State private var content:String = ""
    @Query private var items: [Entry]
    
    var shtctcall = "shortcuts://run-shortcut?name="+SHORTCUT_NAME+"&"+INPUT_LABEL+"="
    
    var body: some View {
        VStack {
            List{
                ForEach(items) { item in
                    HStack{
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
                }
                .onDelete { indexes in
                    for index in indexes {
                        deleteItem(items[index])
                    }
                }
            }
        }
        .onAppear(perform: start)
        .onOpenURL { (url) in
            let input = url.queryParameters![INPUT_LABEL]!
            addItem(input)
            switch url.host() {
            case "":
                print("generic host")
            default:
                print("other host")
                break
            }
        }
    }
    
    
    func addItem(_ itemValue: String) {
        print("adding item")
        let item = Entry(name: itemValue)
        context.insert(item)
    }
    
    func updateItem(_ item: Entry) {
        print("editing item")
        item.name = "updated"
        try? context.save()
    }
    
    func deleteItem(_ item: Entry) {
        print("deleting item")
        context.delete(item)
    }
    
    func start() {
        print("started main view")
    }
    
    func callShortcutWith(_ itemValue: String) {
        print("calling shortcut")
        let shortcut = URL(string: shtctcall+itemValue)!
        UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
    }
}
