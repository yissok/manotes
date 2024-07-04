import SwiftUI
import SwiftData

struct FolderPopup: View {
    @Binding var showPanel:Bool
    @Binding var zSwap:Bool
    @Binding var folderName: String
    @FocusState.Binding var isNewFolderNameFocused: Bool
    
    
    var body: some View {
        return
            VStack {
                TextField("Folder", text: $folderName)
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .font(Font.system(size: 30, design: .default))
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
                    .padding()
                
                HStack {
                    Button(action: {
                        withAnimation {
                            unshow(showPanel: $showPanel, zSwap: $zSwap, isNewFolderNameFocused: $isNewFolderNameFocused)
                        }
                    }) {
                        Text("Add")
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .font(Font.system(size: 30, design: .default))
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }.padding()
            }.frame(height: 300)
            .background(Color(.systemBackground).opacity(0)) // Set the background to transparent
            .cornerRadius(10)
            .shadow(radius: 10)
            .opacity(showPanel ? 1 : 0)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.1), value: showPanel)
        
    }
}
