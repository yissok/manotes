import Foundation

let CONTENT_PASSED="CONTENT_PASSED"
let UN_ID="manotes_uniqueidddddd"
let APP_NAME_URL="manotesURL"
let SHORTCUT_NAME="manoteSHTCT"
let INPUT_LABEL="input"
let LB_ROOT = "ROOT";
let SERIAL_SEPARATOR = "-";
let SERIAL_BACKWARDS = "_";
let SERIAL_CONTENT_SEPARATOR = ":";

let rowHeight:CGFloat=30

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

func printTreeNodeNames(treeNodes: [TreeNode]) {
    print("||||||||||||||||||||||||||||||||||||||") // Add newline for better readability
    for node in treeNodes {
        printTreeNodeDetails(node: node)
    }
    print("______________________________________\n") // Add newline for better readability
}
func printTreeNodeDetails(node: TreeNode) {
    print("Node: \(node.name)")
    
    if let parent = node.parent {
        print("Parent: \(parent.name)")
    } else {
        print("Parent: None")
    }
    
    if node.content != nil
    {
        print("content: \(node.content ?? "none")")
    }
    if !node.children.isEmpty {
        print("              : \(node.children.map { $0.name }.joined(separator: ", "))")
    } else {
        print("              : None")
    }
}

func unwrapNote(noteStr: String) -> TreeNode{
    let note = noteStr.split(separator: ":")
    let noteName = note.count==1 ? String(Int(Date().timeIntervalSince1970.truncate(places: 3)*1000)) : String(note[0])
    let noteContent = note.count==1 ? String(note[0]) : String(note[1])
    return TreeNode(content: noteContent, name: noteName, parent: nil)
}
