

import SwiftUI

struct FilteredFolders: View {
    @EnvironmentObject var contextProvider: ContextProvider
    @State private var showPanel = false
    @State private var ovelayAction:OverlayAction = OverlayAction.unset
    var nodesGlobal:[TreeNode]
    var filteredTags:[TreeNode]
    
    var parent:TreeNode?
    @State private var selectedNode:TreeNode?
    
    
    init(nodesGlobal: [TreeNode] = [], filteredTags: [TreeNode] = [], parent: TreeNode? = nil) {
        self.nodesGlobal = nodesGlobal
        self.filteredTags = filteredTags
        self.parent = parent
        // Initializing non-State properties directly
    }
    
    var body: some View {
        ForEach(filteredTags, id: \.id) { node in
            Tag(nodesGlobal: nodesGlobal, item: node, showPanel: $showPanel, ovelayAction: $ovelayAction, selectedNode: $selectedNode)
        }
        .onDelete { indexes in
            var filteredTagsTemp=filteredTags
            filteredTagsTemp.remove(atOffsets: indexes)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                deleteAt(filteredTagsTemp, indexes, nodesGlobal, contextProvider)
            }
        }
        .onMove { sources, destination in
            move(filteredTags, parent:parent!, from: sources, to: destination)
        }
    }
}
