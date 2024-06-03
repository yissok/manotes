import Foundation
import SwiftData

@Model
class Note2: Identifiable {
    var id: String
    var name: String
    var tag: String
    
    init(name: String, tag: String) {
        self.id = UUID().uuidString
        self.name = name
        self.tag = tag
    }
}
