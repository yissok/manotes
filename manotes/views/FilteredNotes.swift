
import SwiftUI

struct FilteredNotes: View {
    @EnvironmentObject var contextProvider: ContextProvider
    @State private var showPanel = false
    @State private var ovelayAction:OverlayAction = OverlayAction.unset
    var nodesGlobal:[TreeNode]
    var filteredNotes:[TreeNode]
    
    var parent:TreeNode?
    @State private var selectedNode:TreeNode?
    @State private var noteText:String=""
    
    
    init(noteT: Binding<String>, nodesGlobal: [TreeNode] = [], filteredNotes: [TreeNode] = [], parent: TreeNode? = nil) {
        self.noteText = noteT.wrappedValue
        self.nodesGlobal = nodesGlobal
        self.filteredNotes = filteredNotes
        self.parent = parent
        // Initializing non-State properties directly
    }
    
    var body: some View {
        ForEach(Array(zip(filteredNotes.indices, filteredNotes)), id: \.1.id) { index, node in
            Note(nodesGlobal: nodesGlobal, item: node, showPanel: $showPanel, ovelayAction: $ovelayAction, selectedNode: $selectedNode, index:index, noteText: $noteText)
        }
        .onDelete { indexes in
            var filteredNotesTemp=filteredNotes
            filteredNotesTemp.remove(atOffsets: indexes)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                deleteAt(filteredNotesTemp, indexes, nodesGlobal, contextProvider)
            }
        }
        .onMove { sources, destination in
            move(filteredNotes, parent:parent!, from: sources, to: destination)
        }
    }
}
