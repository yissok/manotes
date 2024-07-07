import SwiftUI
import SwiftData

struct FolderPopup: View {
    @Binding var showPanel:Bool
    @Binding var zSwap:Bool
    @Binding var folderName: String
    @FocusState.Binding var isNewFolderNameFocused: Bool
    
    let height:CGFloat=60
    let horizPadSpace:CGFloat=60
    let fontSz:CGFloat=20
    
    var body: some View {
        return
            VStack {
                TextField("Folder", text: $folderName)
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
                        Text("Add")
                            .frame(height: height)
                            .frame(maxWidth: .infinity)
                            .font(Font.system(size: fontSz, design: .default))
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }
                .padding([.horizontal], horizPadSpace)
            }
            .frame(height: 300)
            .background(Color(.systemBackground).opacity(0)) // Set the background to transparent
            .cornerRadius(10)
            .shadow(radius: 10)
            .opacity(showPanel ? 1 : 0)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.1), value: showPanel)
        
    }
}
