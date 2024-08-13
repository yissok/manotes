import SwiftUI
import SwiftData


struct ItemList: View {
    @EnvironmentObject var contextProvider: ContextProvider
    @State var editMode: EditMode = .inactive //<- Declare the @State var for editMode

    @State private var editModeSt=false
    
    @State private var showPanel = false
    @State private var presentNoteInput = false
    @State private var ovelayAction:OverlayAction = OverlayAction.unset
    @State private var newTag = ""
    @State private var treeInput: String = "root-Apple-iphone-11-_-12-_-13"
    @State private var folderName: String = ""
    
    var nodesGlobal:[TreeNode]
    var parent:TreeNode?
    @State private var selectedNode:TreeNode?
    @State private var selectedNodesIds = Set<String>()
    @State private var selectedNodes = Set<TreeNode>()
    @State private var showingSettingsSheet = false
    @State private var showingNewNoteSheet = false
    @State private var newNote:TreeNode=TreeNode(content: "", name: "", parent: nil, orderUnderParent: 0)
    @State private var noteText:String=""


    var body: some View {
        let parentName:String=(parent==nil ? LB_ROOT:parent?.name)!
        var filteredTags:[TreeNode]=nodesGlobal.filter { $0.content == nil && $0.parent == parent }
        var filteredNotes:[TreeNode]=nodesGlobal.filter { $0.content != nil && $0.parent == parent }.sorted(by: { $0.orderUnderParent < $1.orderUnderParent })
//        var filteredNotes:[TreeNode]=parent!.children!.filter { $0.content != nil && $0.content != "" }
//        printTreeNodeNames(treeNodes: nodesGlobal)
        return ZStack
        {
            VStack {
                if parentName != LB_ROOT{
                    Text(parentName)
                        .font(.title)
                }
                List(selection: $selectedNodesIds) {
                    FilteredFolders(nodesGlobal: nodesGlobal, filteredTags: filteredTags, parent: parent)
                    FilteredNotes(noteT: $noteText, nodesGlobal: nodesGlobal, filteredNotes: filteredNotes, parent: parent)
                }
            }
            .onAppear(perform: {
                selectedNodesIds.removeAll()
            })
            .toolbar {
                if !showPanel {
                    if editMode == .active {
                        EditButton()
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .onChange(of: $editMode.wrappedValue, perform: { value in
                withAnimation {
                    editModeSt.toggle()
                }
                if value.isEditing {
                    print("editing")
                } else {
                    print("done")
                }
              })
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    BottomToolbar( editMode: $editMode, editModeSt: $editModeSt, showPanel: $showPanel, presentNoteInput: $presentNoteInput, ovelayAction: $ovelayAction, nodesGlobal: nodesGlobal, selectedNode: $selectedNode, selectedNodesIds: $selectedNodesIds, selectedNodes: $selectedNodes, showingNewNoteSheet: $showingNewNoteSheet, newNote: $newNote, noteText: $noteText, parentName:parentName)
                }
            }
            .toolbar {
                HStack{//you have to keep this else somehow list gets pushed down a step
                    Group {
                        if !showPanel {
                            Menu {
                                Button("Decrypt", action: decryptAll)
                                Button("Edit", action: toggleEditMode)
                                Button("Settings") {
                                    showingSettingsSheet.toggle()
                                    print(showingSettingsSheet)
                                }
                            } label: {
                                Label("", systemImage: "ellipsis.circle")
                                    .transition(.opacity)
                            }
                            .tint(.yellow)
                            .transition(.opacity)
                        } else{
                            Menu {
                            } label: {
                                Label("", systemImage: "ellipsis.circle")
                                    .transition(.opacity).opacity(0)
                            }
                            .tint(.yellow)
                            .navigationBarBackButtonHidden(true)
                        }
                    }
                    .sheet(isPresented: $showingSettingsSheet) {
                        SettingsSheetView()
                    }
                    .animation(.easeInOut, value: showPanel) // Apply the animation
                }
            }
            PopupContainer(showPanel: $showPanel, folderName: $folderName, ovelayAction: $ovelayAction, nodesGlobal: nodesGlobal, parentName: parentName, selectedNode: $selectedNode, selectedNodes: $selectedNodes)
//            deletePlayground()
        }
        func toggleEditMode() {
            withAnimation {
                if editMode == .active {
                    editMode = .inactive
                } else {
                    editMode = .active
                }
            }
        }
        
        func decryptAll() {
            if filteredNotes.count>0{
                callShortcutWith(parentName+"\n"+stackContent(filteredNotes) ?? "no_content")
            }
        }
        
         func stackContent(_ filteredNotes: [TreeNode]) -> String {
             var res=""
             filteredNotes.filter{$0.enc}.forEach { note in
                 res = res+note.name+"_"+note.content!.decodeUrl()+"\n"
             }
             return res
         }
                     
        func randomString(length: Int) -> String {
          let letters = "abcdefghijklmnopqrstuvwxyz"
          return String((0..<length).map{ _ in letters.randomElement()! })
        }
        
    }
}

