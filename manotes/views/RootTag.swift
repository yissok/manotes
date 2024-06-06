import SwiftUI
import SwiftData

struct RootTag: View {
    @EnvironmentObject var contextProvider: ContextProvider
    @Binding var currentViewParentTag:String
    @Binding var tagParent:TreeNode?
    let item: TreeNode
    
    var body: some View {
        return HStack{
            Text(item.name)
            
            Button{
                currentViewParentTag=item.name
                tagParent=item
            } label: {
                Image(systemName: "folder")
            }
            .foregroundColor(Color.blue)
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        
    }
}

