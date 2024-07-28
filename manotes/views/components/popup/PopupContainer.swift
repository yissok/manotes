

import SwiftUI

struct PopupContainer: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var contextProvider: ContextProvider
    @Binding var showPanel:Bool
    @Binding var folderName: String
    @Binding var ovelayAction:OverlayAction
    var nodesGlobal:[TreeNode]
    var parentName:String
    @Binding var selectedNode:TreeNode?
    @Binding var selectedNodes:Set<TreeNode>
    @FocusState var isNewFolderNameFocused: Bool
    
    var body: some View {
        ZStack{

            InputOverlay(showPanel: $showPanel, folderName: $folderName, overlayAction: $ovelayAction, isNewFolderNameFocused: $isNewFolderNameFocused)
                .zIndex(showPanel ? 1 : 0)
            if ovelayAction == OverlayAction.moveNode ||
                ovelayAction == OverlayAction.newFolder ||
                ovelayAction == OverlayAction.bulkMove {
                ShortInput(showPanel: $showPanel, folderName: $folderName, overlayAction: $ovelayAction, isNewFolderNameFocused: $isNewFolderNameFocused)
                    .zIndex(showPanel ? 2 : 0)
            } else if ovelayAction == OverlayAction.newNote || ovelayAction == OverlayAction.editNote {
                LongInput(showPanel: $showPanel, folderName: $folderName, overlayAction: $ovelayAction, isNewFolderNameFocused: $isNewFolderNameFocused)
                    .zIndex(showPanel ? 2 : 0)
            }
            Toggle("Light", isOn: $showPanel)
                .onChange(of: showPanel) {
                    isNewFolderNameFocused=showPanel
                    if !showPanel && folderName != "" {
                        handleNewTagInput(ovelayAction==OverlayAction.newFolder ? parentName : (selectedNode==nil ? "bulkop" : selectedNode!.name),nodesGlobal,folderName, contextProvider.context!, ovelayAction, selectedNodes)
                        selectedNodes=Set<TreeNode>()
                        editMode?.wrappedValue = .inactive
                        folderName=""
                    }
                }
                .opacity(0)

        }
        .ignoresSafeArea(.keyboard)
    }
}
