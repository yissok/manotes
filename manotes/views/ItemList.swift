import SwiftUI
import SwiftData

struct ItemList: View {
    @EnvironmentObject var contextProvider: ContextProvider
    @Query private var notes: [Note2]
    @Query private var tags: [Tag]
    @Binding var currentViewParentTag:String
    var tagParent:Tag?
    
    init(tagParent: Tag?, currentViewParentTag:Binding<String>) {
        self._currentViewParentTag=currentViewParentTag
        self.tagParent=tagParent
        if tagParent != nil {
            let id = tagParent!.persistentModelID
            let predicate = #Predicate<Note2> { note in
                note.parent!.persistentModelID==id
            }
            _notes = Query(filter: predicate)
        } else { // if root level notes
            let predicate = #Predicate<Note2> { note in
                note.parent==nil
            }
            _notes = Query(filter: predicate)
        }
    }
    
    var body: some View {
        return VStack{
            Text(tagParent == nil ? currentViewParentTag:tagParent!.name)
//            Text(tagParent.notes.last!.name)
            List{
                ForEach(tags) { tag in
                    RootTag(item: tag)
                }
                .onDelete { indexes in
                    for index in indexes {
                        deleteTag(tags[index], contextProvider.context!)
                    }
                }
                ForEach(notes) { item in
                    RootNote(currentViewParentTag: $currentViewParentTag, item: item)
                }
                .onDelete { indexes in
                    for index in indexes {
                        deleteItem(notes[index], contextProvider.context!)
                    }
                }
            }
        }
    }
}

