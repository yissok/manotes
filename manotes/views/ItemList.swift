import SwiftUI
import SwiftData

struct ItemList: View {
    @EnvironmentObject var contextProvider: ContextProvider
    @Query private var notes: [Note2]
    @Query private var tags: [Tag]
    
    
    var body: some View {
        return List{
            ForEach(tags) { tag in
                RootTag(item: tag)
            }
            .onDelete { indexes in
                for index in indexes {
                    deleteTag(tags[index], contextProvider.context!)
                }
            }
            ForEach(notes) { item in
                RootNote(item: item)
            }
            .onDelete { indexes in
                for index in indexes {
                    deleteItem(notes[index], contextProvider.context!)
                }
            }
        }
    }
}

