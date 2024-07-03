import SwiftUI
import SwiftData

struct RootView: View {
    
    @EnvironmentObject var contextProvider: ContextProvider
    @Query private var nodesGlobal: [TreeNode]
    
    var body: some View {
        
        func preStart() -> TreeNode {
            print("pre started main view")
            let rootList: [TreeNode]=nodesGlobal.filter({ $0.name == LB_ROOT })
            if rootList.isEmpty {
                let root = TreeNode(content: nil, name: LB_ROOT, parent: nil)
                contextProvider.context!.insert(root)
                return root
            } else {
                return nodesGlobal.filter({ $0.name == LB_ROOT }).first!
            }
        }
        let root = preStart()
        return NavigationStack{
            VStack{
                ItemList(nodesGlobal: nodesGlobal, parent: root)
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

