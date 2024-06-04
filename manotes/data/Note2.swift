import Foundation
import SwiftData

@Model
class Note2: Identifiable {
    var id: String
    var noteContent: String
    var parent: Tag?
    
    init(noteContent: String, parent: Tag?) {
        self.id = UUID().uuidString
        self.noteContent = noteContent
        self.parent = parent
    }
}
