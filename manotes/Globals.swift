import Foundation
import SwiftUI

let CONTENT_PASSED="CONTENT_PASSED"
let UN_ID="manotes_uniqueidddddd"
let APP_NAME_URL="manotesURL"
let SHORTCUT_NAME="manoteSHTCT"
let INPUT_LABEL="input"
let LB_ROOT = "root";
let NOENC_LABEL="NOENC_"
let YESENC_LABEL="YESENC_"

var shtctcall = "shortcuts://run-shortcut?name="+SHORTCUT_NAME+"&input="

let UD_VERSION_NUMBER = "versionNumber";

let DIR_HISTORY = "history";

let SERIAL_SEPARATOR = "-";
let SERIAL_BACKWARDS = "_";
let NOTE_DELIMITER = ":";

let rowHeight:CGFloat=30


enum OverlayAction {
    case unset
    case newFolder
    case moveNode
    case newNote
    case editNote
}




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
extension String {
    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
    
    func encodeUrl() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    func decodeUrl() -> String {
        return self.removingPercentEncoding!
    }
    
    var base64Decoded: String? {
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }

    var base64Encoded: String? {
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
}
extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}






enum DocumentsDirError: Error {
    case dirNotFound
}


func callShortcutWith(_ itemValue: String) {
    print("calling shortcut")
    let shortcut = URL(string: shtctcall+itemValue)!
    UIApplication.shared.open(shortcut, options: [:], completionHandler: nil)
}

func createHistoryIfNotExist() throws {
    if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
        let fileURL = iCloudURL.appendingPathComponent(DIR_HISTORY)
        if !FileManager.default.fileExists(atPath: fileURL.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
                throw DocumentsDirError.dirNotFound
            }
        }
    } else {
        throw DocumentsDirError.dirNotFound
    }
}

func writeToFile(input:String, path:String) throws {
    if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
        let fileURL = iCloudURL.appendingPathComponent(path)
        try? input.data(using: .utf8)?.write(to: fileURL)
    } else {
        throw DocumentsDirError.dirNotFound
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
    if !node.children!.isEmpty {
        print("              : \(node.children!.map { $0.name }.joined(separator: ", "))")
    } else {
        print("              : None")
    }
}

func unwrapNote(noteStr: String, noteDate: String) -> TreeNode{
    var noteName:String
    let note = noteStr.split(separator: ":")
    if noteDate=="0"{
        noteName = note.count==1 ? String(Int(Date().timeIntervalSince1970.truncate(places: 3)*1000)) : String(note[0])
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy_HH-mm-ss"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: noteDate)
        let timeInterval = date!.timeIntervalSince1970
        print("Time in seconds: \(Int(timeInterval))")
        noteName = note.count==1 ? String(Int(timeInterval)*1000) : String(note[0])
    }
    let noteContent = note.count==1 ? String(note[0]) : String(note[1])
    return TreeNode(content: noteContent.decodeUrl(), name: noteName, parent: nil)
}
