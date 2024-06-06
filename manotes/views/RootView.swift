import SwiftUI
import SwiftData

struct RootView: View {
    
    @State private var presentAlert = false
    @State private var newTag = ""
    @State private var currentViewParentTag="root"
    @EnvironmentObject var contextProvider: ContextProvider
    @Query private var tags: [TreeNode]
    
    var body: some View {
        return NavigationView{
            ItemList(tagParent: nil, currentViewParentTag: $currentViewParentTag)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button{
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .foregroundColor(Color.yellow)
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
                            TextField("Username", text: $newTag)
                            Button("Ok", action: {
                                handleNewTagInput(currentViewParentTag,tags,newTag, contextProvider.context!)
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
        }
        .onAppear(perform: start)
        .onOpenURL { (url) in
            handleShortcutInput(url, tags, contextProvider.context!)
        }
        
        
        
        func start() {
            print("started main view")
        }
    }
}

