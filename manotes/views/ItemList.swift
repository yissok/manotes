import SwiftUI
import SwiftData

struct ItemList: View {
    @EnvironmentObject var contextProvider: ContextProvider
    
    @State private var showPanel = false
    @State private var zSwap:Bool = false
    @State private var presentNoteInput = false
    @State private var newTag = ""
    @State private var treeInput: String = "ROOT-Apple-iphone-11-_-12-_-13"
    @State private var folderName: String = ""
    @FocusState private var isNewFolderNameFocused: Bool
    
    var nodesGlobal:[TreeNode]
    var parent:TreeNode?

    var body: some View {
        let parentName:String=(parent==nil ? LB_ROOT:parent?.name)!
        let filteredTags:[TreeNode]=nodesGlobal.filter { $0.content == nil && $0.parent == parent }
        let filteredNotes:[TreeNode]=nodesGlobal.filter { $0.content != nil && $0.parent == parent }
        printTreeNodeNames(treeNodes: nodesGlobal)
        return ZStack
        {
            VStack {
                Text(parentName)
                List {
                    ForEach(filteredTags, id: \.self) { node in
                        RootTag(nodesGlobal: nodesGlobal, item: node)
                    }
                    .onDelete { indexes in
                        deleteAt(filteredTags, indexes)
                    }
                    ForEach(filteredNotes, id: \.self) { node in
                        RootNote(item: node)
                    }
                    .onDelete { indexes in
                        deleteAt(filteredNotes, indexes)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    HStack{
                        Button{
                            
                            withAnimation {
                                showPanel.toggle()
                                zSwap.toggle()
                                isNewFolderNameFocused=true
                            }
                        } label: {
                            Image(systemName: "folder.badge.plus")
                        }
                        .foregroundColor(Color.yellow)
                        .allowsHitTesting(!zSwap)
                        Spacer()
                        Button{
                            presentNoteInput=true
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
                        if filteredNotes.count>0{
                            callShortcutWith(parentName+"\n"+stackContent(filteredNotes) ?? "no_content")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .foregroundColor(Color.yellow)
                }
            }
            .zIndex(zSwap ? 0 : 1)
            InputOverlay(showPanel: $showPanel, zSwap: $zSwap, folderName: $folderName, isNewFolderNameFocused: $isNewFolderNameFocused)
                .zIndex(zSwap ? 1 : 0)
            FolderPopup(showPanel: $showPanel, zSwap: $zSwap, folderName: $folderName, isNewFolderNameFocused: $isNewFolderNameFocused)
                .zIndex(zSwap ? 2 : 0)
            
            Toggle("Light", isOn: $zSwap)
                .onChange(of: zSwap) {
                    if !zSwap && folderName != "" {
                        print("new folder name.")
                        handleNewTagInput(parentName,nodesGlobal,folderName, contextProvider.context!)
                        folderName=""
                    }
                }
                .opacity(0)
            

        }
                     
         func stackContent(_ filteredNotes: [TreeNode]) -> String {
             var res=""
             filteredNotes.forEach { note in
                 res = res+note.name+"_"+note.content!.replacingOccurrences(of: "%3D", with: "")+"\n"
             }
             return res
         }
                     
        func randomString(length: Int) -> String {
          let letters = "abcdefghijklmnopqrstuvwxyz"
          return String((0..<length).map{ _ in letters.randomElement()! })
        }
        
        func deleteAt(_ filteredNodes:[TreeNode], _ indexes:IndexSet) {
            for index in indexes {
                if let globalIndex = nodesGlobal.firstIndex(of: filteredNodes[index]) {
                    handleDeletionInput(nodesGlobal[globalIndex].name, nodesGlobal,contextProvider.context!)
                }
            }
        }
        
    }
}

