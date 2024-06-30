import SwiftUI
import SwiftData

struct ItemList: View {
    @EnvironmentObject var contextProvider: ContextProvider
    
    @State private var presentAlert = false
    @State private var newTag = ""
    @State private var treeInput: String = "ROOT-Apple-iphone-11-_-12-_-13-_-14-_-15-_-6-_-7-_-8-_-X-_-_-_-Nvidia-_-"
    
    var nodesGlobal:[TreeNode]
    var parent:TreeNode?

    var body: some View {
        let parentName:String=(parent==nil ? LB_ROOT:parent?.name)!
        let filteredTags:[TreeNode]=nodesGlobal.filter { $0.content == nil && $0.parent == parent }
        let filteredNotes:[TreeNode]=nodesGlobal.filter { $0.content != nil && $0.parent == parent }
        return
                VStack{
                    Text(parentName)
                    List {
                        ForEach(filteredTags, id: \.self) { node in
                            RootTag(nodesGlobal: nodesGlobal, item: node)
                        }
                        .onDelete { indexes in
                            for index in indexes {
                                if let globalIndex = nodesGlobal.firstIndex(of: filteredTags[index]) {
                                    deleteTag(nodesGlobal[globalIndex], contextProvider.context!)
                                }
                            }
                        }
                        ForEach(filteredNotes, id: \.self) { node in
                            RootNote(item: node)
                        }
                        .onDelete { indexes in
                            for index in indexes {
                                if let globalIndex = nodesGlobal.firstIndex(of: filteredNotes[index]) {
                                    deleteItem(nodesGlobal[globalIndex], contextProvider.context!)
                                }
                            }
                        }
                    }
                    
                    
                    
                    TextField("treeInput", text: $treeInput)
                        .autocorrectionDisabled()
                    Button{
                        TreeNode.insertTree(treeInput,nodesGlobal, context: contextProvider.context!)
                    } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                    .foregroundColor(Color.yellow)

            }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack{
                            Button{
                                
                                presentAlert=true
                                
                                handleNewTagInput(parentName,nodesGlobal,randomString(length: 4), contextProvider.context!)
                            } label: {
                                Image(systemName: "folder.badge.plus")
                            }
                            .foregroundColor(Color.yellow)
//                            .alert("Tag name", isPresented: $presentAlert, actions: {
//                                TextField(parentName, text: $newTag)
//                                Button("Ok", action: {
//                                    handleNewTagInput(parentName,nodesGlobal,newTag, contextProvider.context!)
//                                })
//                                Button("Cancel", role: .cancel, action: {})
//                            }, message: {
//                                Text("Enter the name for the tag folder")
//                            })
                            Spacer()
                            Button{
                                handleNewNoteInput(parentName,nodesGlobal,"iam a test note", contextProvider.context!)
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
        func randomString(length: Int) -> String {
          let letters = "abcdefghijklmnopqrstuvwxyz"
          return String((0..<length).map{ _ in letters.randomElement()! })
        }
    }
}

