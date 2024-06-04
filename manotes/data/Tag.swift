import Foundation
import SwiftData

@Model
class Tag: Identifiable {
    var id: String
    var name: String
    var parent: Tag?
    
    
    init(name: String, parent: Tag?) {
        self.id = UUID().uuidString
        self.name = name
        self.parent = parent
    }
}
