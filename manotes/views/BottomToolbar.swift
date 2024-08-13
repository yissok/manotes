//
//  BottomToolbar.swift
//  manotes
//
//  Created by andrea on 13/08/24.
//

import SwiftUI

struct BottomToolbar: View {
    @EnvironmentObject var contextProvider: ContextProvider
    @Binding var editMode: EditMode
    @Binding var editModeSt: Bool
    @Binding var showPanel: Bool
    @Binding var presentNoteInput: Bool
    @Binding var ovelayAction: OverlayAction
    var nodesGlobal: [TreeNode]
    @Binding var selectedNode: TreeNode?
    @Binding var selectedNodesIds: Set<String>
    @Binding var selectedNodes: Set<TreeNode>
    @Binding var showingNewNoteSheet: Bool
    @Binding var newNote: TreeNode
    @Binding var noteText: String
    var parentName: String

    // Init function accepting the bindings
    init(
       editMode: Binding<EditMode> = .constant(.inactive),
       editModeSt: Binding<Bool> = .constant(false),
       showPanel: Binding<Bool> = .constant(false),
       presentNoteInput: Binding<Bool> = .constant(false),
       ovelayAction: Binding<OverlayAction> = .constant(.unset),
       nodesGlobal: [TreeNode] = [],
       selectedNode: Binding<TreeNode?> = .constant(nil),
       selectedNodesIds: Binding<Set<String>> = .constant([]),
       selectedNodes: Binding<Set<TreeNode>> = .constant([]),
       showingNewNoteSheet: Binding<Bool> = .constant(false),
       newNote: Binding<TreeNode> = .constant(TreeNode(content: "", name: "", parent: nil, orderUnderParent: 0)),
       noteText: Binding<String> = .constant(""),
       parentName: String
    ) {
       self._editMode = editMode
       self._editModeSt = editModeSt
       self._showPanel = showPanel
       self._presentNoteInput = presentNoteInput
       self._ovelayAction = ovelayAction
       self.nodesGlobal = nodesGlobal
       self._selectedNode = selectedNode
       self._selectedNodesIds = selectedNodesIds
       self._selectedNodes = selectedNodes
       self._showingNewNoteSheet = showingNewNoteSheet
       self._newNote = newNote
       self._noteText = noteText
       self.parentName = parentName
    }

    var body: some View {
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
                NoteView(note: newNote, isNew: true, noteT: $noteText)
            }
            .onChange(of: showingNewNoteSheet, {
                if !showingNewNoteSheet {
                    onSheetDismissed(nodesGlobal, contextProvider, newNote, noteText)
                }
            })
        }
    }
}
