import SwiftUI
import SwiftData

struct RootTag: View {
    @EnvironmentObject var contextProvider: ContextProvider
    var nodesGlobal:[TreeNode]
    let item: TreeNode
    
    var body: some View {
        return HStack{
//            Text(item.parent == nil ? "r" : item.parent!.name).bold()
            NavigationLink(item.name) {
                ItemList(nodesGlobal: nodesGlobal, parent: item)
            }
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        
    }
}

