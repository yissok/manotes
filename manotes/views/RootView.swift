import SwiftUI
import SwiftData

struct RootView: View {
    
    @State private var presentAlert = false
    @State private var tag = ""
    @EnvironmentObject var contextProvider: ContextProvider
    
    var body: some View {
        return NavigationView{
            ItemList()
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
                            TextField("Username", text: $tag)
                            Button("Ok", action: {
                                handleNewTagInput(tag, contextProvider.context!)
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
            handleShortcutInput(url, contextProvider.context!)
        }
        
        
        
        func start() {
            print("started main view")
        }
    }
}

