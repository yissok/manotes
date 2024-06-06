import SwiftUI
import SwiftData

struct ItemList: View {
    @EnvironmentObject var contextProvider: ContextProvider
    
    @Query private var folders: [TreeNode]
    @Query private var files: [TreeNode]
    
    @Binding var currentViewParentTag:String
    @State var tagParent:TreeNode?
    
    init(tagParent: TreeNode?, currentViewParentTag:Binding<String>) {
        self._currentViewParentTag=currentViewParentTag
        initCoreData(tagParent: tagParent)
    }
    mutating func initCoreData(tagParent: TreeNode?) {
        self.tagParent=tagParent
        if tagParent != nil {
            let id = tagParent!.persistentModelID
            let predicateFolders = #Predicate<TreeNode> { note in
                note.parent!.persistentModelID==id && note.content == nil
            }
            _folders = Query(filter: predicateFolders)
            let predicateFiles = #Predicate<TreeNode> { note in
                note.parent!.persistentModelID==id && note.content != nil
            }
            _files = Query(filter: predicateFiles)
        } else { // if root level notes
            let predicateFolders = #Predicate<TreeNode> { note in
                note.parent==nil && note.content == nil
            }
            _folders = Query(filter: predicateFolders)
            let predicateFiles = #Predicate<TreeNode> { note in
                note.parent==nil && note.content != nil
            }
            _files = Query(filter: predicateFiles)
        }
    }
    
    var body: some View {
        return VStack{
            Text(tagParent == nil ? currentViewParentTag:tagParent!.name)
                .onChange(of: currentViewParentTag) {
//                    initCoreData(tagParent: tagParent)
                }
            List{
                ForEach(folders) { tag in
                    RootTag(currentViewParentTag: $currentViewParentTag, tagParent: $tagParent, item: tag)
                }
                .onDelete { indexes in
                    for index in indexes {
                        deleteTag(folders[index], contextProvider.context!)
                    }
                }
                ForEach(files) { file in
                    RootNote(currentViewParentTag: $currentViewParentTag, item: file)
                }
                .onDelete { indexes in
                    for index in indexes {
                        deleteItem(files[index], contextProvider.context!)
                    }
                }
            }
        }
    }
}

