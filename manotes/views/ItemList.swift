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

    var body: some View {
        let parentName:String=(parent==nil ? LB_ROOT:parent?.name)!
        var filteredTags:[TreeNode]=nodesGlobal.filter { $0.content == nil && $0.parent == parent }
        var filteredNotes:[TreeNode]=nodesGlobal.filter { $0.content != nil && $0.parent == parent }
        printTreeNodeNames(treeNodes: nodesGlobal)
        return ZStack
        {
            VStack {
                Text(parentName)
                List(selection: $selectedNodesIds) {
                    ForEach(filteredTags, id: \.id) { node in
                        Tag(nodesGlobal: nodesGlobal, item: node, showPanel: $showPanel, ovelayAction: $ovelayAction, selectedNode: $selectedNode)
                    }
                    .onDelete { indexes in
                        let filteredTagsTemp=filteredTags
                        filteredTags.remove(atOffsets: indexes)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            deleteAt(filteredTagsTemp, indexes)
                        }
                    }
                    ForEach(filteredNotes, id: \.id) { node in
                        Note(item: node, showPanel: $showPanel, ovelayAction: $ovelayAction, selectedNode: $selectedNode)
                            .listRowBackground(node.enc ? Color.red : Color.green)
                    }
                    .onDelete { indexes in
                        let filteredNotesTemp=filteredNotes
                        filteredNotes.remove(atOffsets: indexes)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            deleteAt(filteredNotesTemp, indexes)
                        }
                    }
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
                    HStack{
                        Button{
                            if editModeSt {
                                var i=0
                                print("move")
                                selectedNodesIds.forEach { st in
                                    i += 1
                                    let toBeMoved = nodesGlobal.filter{$0.id==st}.first
                                    if toBeMoved != nil{
                                        selectedNodes.insert(toBeMoved!)
                                        print("\(i): \(toBeMoved!.name )")
                                    }
                                }
                                withAnimation {
                                    showPanel.toggle()
                                    ovelayAction=OverlayAction.bulkMove
                                }
                            } else {
                                withAnimation {
                                    showPanel.toggle()
                                    ovelayAction=OverlayAction.newFolder
                                }
                            }
                        } label: {
                            if editModeSt {
                                Text("Move Selected")
                            } else {
                                Image(systemName: "folder.badge.plus")
                            }
                        }
                        .foregroundColor(Color.yellow)
                        .allowsHitTesting(!showPanel)//make buttons untouchable when popup is active
                        Spacer()
                        Button{
                            if editModeSt {
                                var i=0
                                print("delete")
                                selectedNodesIds.forEach { st in
                                    i += 1
                                    let toBeDeleted = nodesGlobal.filter{$0.id==st}.first
                                    if toBeDeleted != nil{
                                        let toBeDeletedName = toBeDeleted!.name
                                        handleDeletionInput(toBeDeletedName, nodesGlobal, contextProvider.context!)
                                        print("\(i): \(toBeDeletedName )")
                                    }
                                }
                            } else {
                                presentNoteInput=true
                                handleNewNoteInput(parentName,nodesGlobal,"iam a test note".base64Encoded!, contextProvider.context!)
                            }
                        } label: {
                            if editModeSt {
                                Text("Delete Selected")
                            } else {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                        .foregroundColor(Color.yellow)
                        .allowsHitTesting(!showPanel)//make buttons untouchable when popup is active
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Group {
                        if !showPanel {
                            Menu {
                                Button("Decrypt All", action: decryptAll)
                                Button("Edit", action: toggleEditMode)
                                Menu("Export") {
                                    Button("As filesystem .zip", action: fsExport)
                                    Button("As manotes format", action: manotesExport)
                                }
                                Button("Import", action: importTree)
                                Button("Settings", action: settingsView)
                            } label: {
                                Label("", systemImage: "ellipsis.circle")
                            }
                            .tint(.yellow)
                            .transition(.opacity)
                        } else{
                            Label("", systemImage: "ellipsis.circle").opacity(0)
                                .navigationBarBackButtonHidden(true)
                        }
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
        func fsExport() { }
        func manotesExport() { }
        func importTree() { }
        func settingsView() { }
        
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
        
        func deleteAt(_ filteredNodes:[TreeNode], _ indexes:IndexSet) {
            for index in indexes {
                if let globalIndex = nodesGlobal.firstIndex(of: filteredNodes[index]) {
                    handleDeletionInput(nodesGlobal[globalIndex].name, nodesGlobal,contextProvider.context!)
                }
            }
        }
        
    }
}

