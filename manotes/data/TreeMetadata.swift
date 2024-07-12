import Foundation
import SwiftData

@Model
class TreeMetadata: Identifiable {
    var versionNumber:Int = -1
    
    init(versionNumber: Int) {
        self.versionNumber = versionNumber
    }
}
