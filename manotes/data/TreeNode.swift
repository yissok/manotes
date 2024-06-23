import Foundation
import SwiftData

@Model
class TreeNode: Identifiable {
    var id: String
    var name: String
    var content: String?
    var children: [TreeNode] = []
    var parent: TreeNode?
    
    init(content: String?, name: String, parent:TreeNode?) {
        self.id = UUID().uuidString
        self.content = content
        self.name = name
        self.parent = parent
    }
    
    static func getSingleBranchTree(_ filesystem:TreeNode) -> String{
        return "a";
    }
    static func getCurrentNode(_ filesystem:TreeNode, _ folderLevel:String) -> TreeNode{
        return TreeNode(content: "", name: "", parent: nil)
    }
    
    static func deSerialise(_ strFilesystem:String) -> TreeNode{
        return TreeNode(content: "", name: "", parent: nil)
    }
}
