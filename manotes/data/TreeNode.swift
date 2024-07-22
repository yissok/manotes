import Foundation
import SwiftData

@Model
class TreeNode: Identifiable {
    var id: String=""
    var name: String=""
    var content: String?=nil
    var children: [TreeNode]? = []
    var parent: TreeNode?=nil
    var enc: Bool=true
    
    @Relationship(inverse: \TreeNode.parent) var childrenINVERSE: [TreeNode]?
    @Relationship(inverse: \TreeNode.children) var parentINVERSE: TreeNode?
    
    init(content: String?, name: String, parent:TreeNode?) {
        var tmpContent = content
        if tmpContent != nil {
            if tmpContent!.starts(with: "@") {
                tmpContent=tmpContent!.replacingOccurrences(of: "@", with: "")
                self.enc=true
            } else {
                self.enc=false
            }
        }
        self.id = UUID().uuidString
        self.content = tmpContent
        self.name = name
        self.parent = parent
        children = []
    }
}
