import SwiftUI

struct NoteView: View {
    @EnvironmentObject var contextProvider: ContextProvider
    var note:TreeNode
    @State private var isNew:Bool
    
    @FocusState var isFocused: Bool
    @State private var noteText:String
    @Environment(\.dismiss) var dismiss
    
    init(note:TreeNode, isNew: Bool) {
        self.isNew = isNew
        self.note = note
        noteText = note.content!.base64Decoded ?? note.content!
    }
    
    var body: some View {
        NavigationStack {
            TextEditor(text: $noteText)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .navigationTitle(note.parent!.name)
                .focused($isFocused)
        }
        .onAppear {
            if isNew{
                isFocused = true
            }
        }
        if note.content!.base64Decoded != noteText {
            Button{
                note.content=noteText.base64Encoded
                contextProvider.context?.insert(note)
                dismiss()
            } label: {
                BigButton(content: "Save", bgColor: Color(.secondaryLabel))
            }
            .foregroundColor(Color.yellow)
            .padding()
        }
//        Button("Close") {
//            dismiss()
//        }
//        .font(.title)
//        .padding()
    }
}
