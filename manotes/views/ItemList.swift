import SwiftUI
import SwiftData

struct ItemList: View {
    @EnvironmentObject var contextProvider: ContextProvider
    
//    @Query private var folders: [TreeNode]
//    @Query private var files: [TreeNode]
    
    var folders:[TreeNode]
    
//    init(tagParent: [TreeNode]) {
//        self.tagParent=tagParent
//        if tagParent != nil {
//            let id = tagParent!.persistentModelID
//            let predicateFolders = #Predicate<TreeNode> { note in
//                 note.content == nil//note.parent!.persistentModelID==id &&
//            }
//            _folders = Query(filter: predicateFolders)
//            let predicateFiles = #Predicate<TreeNode> { note in
//                note.content != nil//note.parent!.persistentModelID==id &&
//            }
//            _files = Query(filter: predicateFiles)
//        } else { // if root level notes
//            let predicateFolders = #Predicate<TreeNode> { note in
//                note.parent==nil && note.content == nil
//            }
//            _folders = Query(filter: predicateFolders)
//            let predicateFiles = #Predicate<TreeNode> { note in
//                note.parent==nil && note.content != nil
//            }
//            _files = Query(filter: predicateFiles)
//        }
//    }
    
    var body: some View {
        return NavigationView {
                VStack{
//                    Text(tagParent == nil ? "aa":tagParent!.name)
//                        .onChange(of: currentViewParentTag) {
//        //                    initCoreData(tagParent: tagParent)
//                        }
                    
                    List{
                        ForEach(folders) { tag in
                            RootTag(item: tag)
                        }
                        .onDelete { indexes in
                            for index in indexes {
                                deleteTag(folders[index], contextProvider.context!)
                            }
                        }
//                        ForEach(files) { file in
//                            RootNote(item: file)
//                        }
//                        .onDelete { indexes in
//                            for index in indexes {
//                                deleteItem(files[index], contextProvider.context!)
//                            }
//                        }
                }
//                NavigationLink {
//                    ItemList(tagParent: folders.first, currentViewParentTag: $currentViewParentTag)
//                } label: {
//                    VStack {
//                        Image(systemName: "folder")
//                    }
//                    .padding()
//                }.simultaneousGesture(TapGesture().onEnded {
//                    print("simultaneousGesture!")
//    //                currentViewParentTag=item.name
//                })
            }
        }
    }
}

