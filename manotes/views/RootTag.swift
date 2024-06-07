import SwiftUI
import SwiftData

struct RootTag: View {
    @EnvironmentObject var contextProvider: ContextProvider
    let item: TreeNode
    
    var body: some View {
        return HStack{
            Text(item.name)
            
            NavigationLink {
                ItemList(folders: item.children)
            } label: {
                VStack {
                    Image(systemName: "folder")
                }
                .padding()
            }.simultaneousGesture(TapGesture().onEnded {
                print("simultaneousGesture!")
            })
//            Button{
//                currentViewParentTag=item.name
//                tagParent=item
//            } label: {
//                Image(systemName: "folder")
//            }
//            .foregroundColor(Color.blue)
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        
    }
}

