import SwiftUI
import SwiftData



struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        Button("Export", action: exportTree)
            .font(.title)
            .padding()
        Button("Import", action: importTree)
            .font(.title)
            .padding()
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
    }
    
    
    func exportTree() { }
    func importTree() { }
}


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
    @State private var newNote:TreeNode=TreeNode(content: "", name: "", parent: nil)


    var body: some View {
        let parentName:String=(parent==nil ? LB_ROOT:parent?.name)!
        var filteredTags:[TreeNode]=nodesGlobal.filter { $0.content == nil && $0.parent == parent }
        var filteredNotes:[TreeNode]=nodesGlobal.filter { $0.content != nil && $0.parent == parent }
//        var filteredNotes:[TreeNode]=nodesGlobal.filter { $0.content != nil && $0.content != "" && $0.parent == parent }
//        printTreeNodeNames(treeNodes: nodesGlobal)
        return ZStack
        {
            VStack {
                Text(parentName)
                    .font(.title)
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
                    ForEach(Array(zip(filteredNotes.indices, filteredNotes)), id: \.1.id) { index, node in
                        Note(nodesGlobal: nodesGlobal, item: node, showPanel: $showPanel, ovelayAction: $ovelayAction, selectedNode: $selectedNode, index:index)
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
                                newNote = handleNewNoteInput(parentName,nodesGlobal,"".base64Encoded!, contextProvider.context!)
                                print(newNote.parent?.name)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    showingNewNoteSheet.toggle()
                                }
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
                        .sheet(isPresented: $showingNewNoteSheet) {
                            NoteView(note: newNote, isNew: true)
                        }
                        .onChange(of: showingNewNoteSheet) { newValue in
                            if !newValue {
                                // This will be called when the sheet is dismissed
                                onSheetDismissed()
                            }
                        }
                    }
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
                        SheetView()
                    }
                    .animation(.easeInOut, value: showPanel) // Apply the animation
                }
            }
            PopupContainer(showPanel: $showPanel, folderName: $folderName, ovelayAction: $ovelayAction, nodesGlobal: nodesGlobal, parentName: parentName, selectedNode: $selectedNode, selectedNodes: $selectedNodes)
//            deletePlayground()
        }
        
        func onSheetDismissed() {
            // Your callback logic here
            print("The sheet was dismissed")
            if let index = nodesGlobal.firstIndex(where: { $0.content == "" }) {
                print("Index content to delete: \(nodesGlobal[index].content)")
                handleDeletionInput(nodesGlobal[index].name, nodesGlobal,contextProvider.context!)
            } else {
                print("No element found with content == \"\"")
            }
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
        
        func deleteAt(_ filteredNodes:[TreeNode], _ indexes:IndexSet) {
            for index in indexes {
                if let globalIndex = nodesGlobal.firstIndex(of: filteredNodes[index]) {
                    handleDeletionInput(nodesGlobal[globalIndex].name, nodesGlobal,contextProvider.context!)
                }
            }
        }
        
    }
}
