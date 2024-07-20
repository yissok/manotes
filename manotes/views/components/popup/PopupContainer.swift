

import SwiftUI

struct PopupContainer: View {
    @EnvironmentObject var contextProvider: ContextProvider
    @Binding var showPanel:Bool
    @Binding var folderName: String
    @Binding var ovelayAction:OverlayAction
    var nodesGlobal:[TreeNode]
    var parentName:String
    @Binding var selectedNode:TreeNode?
    @FocusState var isNewFolderNameFocused: Bool
    
    var body: some View {
        InputOverlay(showPanel: $showPanel, folderName: $folderName, overlayAction: $ovelayAction, isNewFolderNameFocused: $isNewFolderNameFocused)
            .zIndex(showPanel ? 1 : 0)
        FolderPopup(showPanel: $showPanel, folderName: $folderName, isNewFolderNameFocused: $isNewFolderNameFocused)
            .zIndex(showPanel ? 2 : 0)
        Toggle("Light", isOn: $showPanel)
            .onChange(of: showPanel) {
                isNewFolderNameFocused=showPanel
                if !showPanel && folderName != "" {
                    print("new folder name.")
                    handleNewTagInput(ovelayAction==OverlayAction.newFolder ? parentName : selectedNode!.name,nodesGlobal,folderName, contextProvider.context!, ovelayAction)
                    folderName=""
                }
            }
            .opacity(0)
    }
}
