import SwiftUI
import SwiftData

struct RootView: View {
    @EnvironmentObject var contextProvider: ContextProvider
    @State private var content:String = ""
    @Query private var items: [Entry]
    
    
    var body: some View {
        return VStack {
            List{
                ForEach(items) { item in
                    RootItem(item: item)
                }
                .onDelete { indexes in
                    for index in indexes {
                        deleteItem(items[index], contextProvider.context!)
                    }
                }
            }
        }
        .onAppear(perform: start)
        .onOpenURL { (url) in
            handleInput(url, contextProvider.context!)
        }
        
        
        func start() {
            print("started main view")
        }
    }
}

