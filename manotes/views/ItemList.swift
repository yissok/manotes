import SwiftUI
import SwiftData

struct ItemList: View {
    @EnvironmentObject var contextProvider: ContextProvider
    
    @State private var presentAlert = false
    @State private var newTag = ""
    @State private var currentViewParentTag="root"
    var nodes:[TreeNode]
    
    var body: some View {
        return 
                VStack{
//                    Text(tagParent == nil ? "aa":tagParent!.name)
//                        .onChange(of: currentViewParentTag) {
//        //                    initCoreData(tagParent: tagParent)
//                        }
                    
                    List{
                        ForEach(nodes.filter { $0.content==nil }) { node in
                            RootTag(item: node)
                        }
                        .onDelete { indexes in
                            for index in indexes {
                                deleteTag(nodes[index], contextProvider.context!)
                            }
                        }
                        ForEach(nodes.filter { $0.content != nil }) { node in
                            RootNote(item: node)
                        }
                        .onDelete { indexes in
                            for index in indexes {
                                deleteItem(nodes[index], contextProvider.context!)
                            }
                        }
                }
            }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack{
                            Button{
                                
                                presentAlert=true
                            } label: {
                                Image(systemName: "folder.badge.plus")
                            }
                            .foregroundColor(Color.yellow)
                            .alert("Tag name", isPresented: $presentAlert, actions: {
                                TextField("parent", text: $currentViewParentTag)
                                TextField("new", text: $newTag)
                                Button("Ok", action: {
                                    handleNewTagInput(currentViewParentTag,nodes,newTag, contextProvider.context!)
                                })
                                Button("Cancel", role: .cancel, action: {})
                            }, message: {
                                Text("Enter the name for the tag folder")
                            })
                            Spacer()
                            Button{
                                
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                            .foregroundColor(Color.yellow)
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button{
                            
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        .foregroundColor(Color.yellow)
                    }
                }
        
    }
}

