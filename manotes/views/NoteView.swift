import SwiftUI

struct NoteView: View {
    
    var note:TreeNode
    var dayDate:String
    var hourDate:String
    
    @State private var noteText:String
    
    init(note:TreeNode, dayDate:String, hourDate:String) {
        self.note = note
        self.dayDate = dayDate
        self.hourDate = hourDate
        noteText = note.content!.base64Decoded ?? note.content!
    }
    
    var body: some View {
        NavigationStack {
            TextEditor(text: $noteText)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .navigationTitle(note.parent!.name + " note")
        }
        Button{
        } label: {
            BigButton(content: "Save", bgColor: Color(.secondaryLabel))
        }
        .foregroundColor(Color.yellow)
        .padding()
    }
}
