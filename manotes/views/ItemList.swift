import SwiftUI
import SwiftData

struct ItemList: View {
    @EnvironmentObject var contextProvider: ContextProvider
    
    @State private var showPanel = false
    @State private var presentNoteInput = false
    @State private var ovelayAction:OverlayAction = OverlayAction.unset
    @State private var newTag = ""
    @State private var treeInput: String = "root-Apple-iphone-11-_-12-_-13"
    @State private var folderName: String = ""
    
    var nodesGlobal:[TreeNode]
    var parent:TreeNode?
    @State private var selectedNode:TreeNode?

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
                        Tag(nodesGlobal: nodesGlobal, item: node, showPanel: $showPanel, ovelayAction: $ovelayAction, selectedNode: $selectedNode)
                    }
                    .onDelete { indexes in
                        deleteAt(filteredTags, indexes)
                    }
                    ForEach(filteredNotes, id: \.self) { node in
                        Note(item: node)
                            .listRowBackground(node.enc ? Color.red : Color.green)
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
                                ovelayAction=OverlayAction.newFolder
                            }
                        } label: {
                            Image(systemName: "folder.badge.plus")
                        }
                        .foregroundColor(Color.yellow)
                        .allowsHitTesting(!showPanel)//make buttons untouchable when popup is active
                        Spacer()
                        Button{
                            presentNoteInput=true
                            handleNewNoteInput(parentName,nodesGlobal,"iam a test note".base64Encoded!, contextProvider.context!)
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .foregroundColor(Color.yellow)
                        .allowsHitTesting(!showPanel)//make buttons untouchable when popup is active
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
                    .allowsHitTesting(!showPanel)//make buttons untouchable when popup is active
                }
            }
            PopupContainer(showPanel: $showPanel, folderName: $folderName, ovelayAction: $ovelayAction, nodesGlobal: nodesGlobal, parentName: parentName, selectedNode: $selectedNode)
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

