import SwiftUI
import SwiftData

struct RootTag: View {
    @EnvironmentObject var contextProvider: ContextProvider
    let item: TreeNode
    
    var body: some View {
        return HStack{
            NavigationLink(item.name) {
                ItemList(nodes: item.children)
            }
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        
    }
}

