import SwiftUI
import SwiftData

struct RootView: View {
    
    @EnvironmentObject var contextProvider: ContextProvider
    @Query(filter: #Predicate<TreeNode> { $0.parent == nil },
           sort: [SortDescriptor(\TreeNode.name)] ) private var nodes: [TreeNode]
    
    var body: some View {
        return NavigationStack{
            VStack{
                ItemList(nodes: nodes)
            }
            
        }
        .onAppear(perform: start)
        .onOpenURL { (url) in
            handleShortcutInput(url, nodes, contextProvider.context!)
        }
        
        
        
        func start() {
            print("started main view")
        }
    }
}

