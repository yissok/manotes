import SwiftUI
import SwiftData

struct RootView: View {
    
    @EnvironmentObject var contextProvider: ContextProvider
    @Query private var nodesGlobal: [TreeNode]
    
    var body: some View {
        return NavigationStack{
            VStack{
                ItemList(nodesGlobal: nodesGlobal, parent: nil)
            }
            
        }
        .onAppear(perform: start)
        .onOpenURL { (url) in
            handleShortcutInput(url, nodesGlobal, contextProvider.context!)
        }
        
        
        
        func start() {
            print("started main view")
        }
    }
}

