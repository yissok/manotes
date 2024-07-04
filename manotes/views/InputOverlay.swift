import SwiftUI
import SwiftData

struct InputOverlay: View {
    @Binding var showPanel:Bool
    @Binding var zSwap:Bool
    @Binding var folderName: String
    @FocusState.Binding var isNewFolderNameFocused: Bool
    
    
    var body: some View {
        return Color.yellow.opacity(showPanel ? 0.4 : 0)
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
