import SwiftUI
import SwiftData

struct FolderPopup: View {
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
    let height:CGFloat=60
    let horizPadSpace:CGFloat=100
    let fontSz:CGFloat=20
    
    var body: some View {
        return
            VStack {
                TextField(overlayAction==OverlayAction.newFolder ? "Folder" : "Destination", text: $folderName)
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .font(Font.system(size: fontSz, design: .default))
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 20)
                    .background(Color(.systemBackground))
                    .focused($isNewFolderNameFocused)
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation {
                            isNewFolderNameFocused=true
                        }
                    }
                    .padding([.horizontal], horizPadSpace)
                
                HStack {
                    Button(action: {
                        withAnimation {
                            unshow(showPanel: $showPanel, zSwap: $zSwap, isNewFolderNameFocused: $isNewFolderNameFocused)
                        }
                    }) {
                        Text(overlayAction==OverlayAction.newFolder ? "Add" : "Move")
                            .frame(height: height)
                            .frame(maxWidth: .infinity)
                            .font(Font.system(size: fontSz, design: .default))
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }
                .padding([.horizontal], horizPadSpace)
                Spacer()
            }
            .background(Color(.systemBackground).opacity(0)) // Set the background to transparent
            .cornerRadius(10)
            .shadow(radius: 10)
            .opacity(showPanel ? 1 : 0)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.1), value: showPanel)
        
    }
}
