import SwiftUI
import SwiftData

struct RootTag: View {
    @EnvironmentObject var contextProvider: ContextProvider
    let item: Tag
    
    var body: some View {
        return HStack{
            Text(item.name)
        }
        .frame(minHeight: rowHeight, maxHeight: rowHeight)
        
    }
}

