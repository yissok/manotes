import SwiftUI
import SwiftData

struct InputOverlay: View {
    @Binding var showPanel:Bool
    @Binding var folderName: String
    @Binding<OverlayAction> var overlayAction:OverlayAction
    
    @FocusState.Binding var isNewFolderNameFocused: Bool
    @State var zSwap:Bool
    init(showPanel: Binding<Bool>, folderName: Binding<String>, overlayAction: Binding<OverlayAction>, isNewFolderNameFocused: FocusState<Bool>.Binding) {
        self._showPanel = showPanel
        self._folderName = folderName
        self._overlayAction = overlayAction
        self._isNewFolderNameFocused = isNewFolderNameFocused
        self._zSwap = State<Bool>(wrappedValue: showPanel.wrappedValue)
    }

    var body: some View {
        let col = overlayAction==OverlayAction.newFolder ? Color.yellow : Color.green
        return col.opacity(showPanel ? 0.4 : 0)
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
            .animation(.easeInOut, value: showPanel)
            .onTapGesture {
                withAnimation {
                    unshow(showPanel: $showPanel, zSwap: $zSwap, isNewFolderNameFocused: $isNewFolderNameFocused)
                    folderName=""
                }
            }
            .allowsHitTesting(showPanel)
        
    }
}

func unshow(showPanel: Binding<Bool>, zSwap: Binding<Bool>, isNewFolderNameFocused: FocusState<Bool>.Binding) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
        zSwap.wrappedValue.toggle()
    }
    showPanel.wrappedValue.toggle()
    if isNewFolderNameFocused.wrappedValue {
        isNewFolderNameFocused.wrappedValue.toggle()
    }
}
