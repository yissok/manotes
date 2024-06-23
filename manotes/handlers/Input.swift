import Foundation
import SwiftData


func handleNewTagInput(_ currentTag: String,_ tags: [TreeNode], _ name: String, _ context: ModelContext) {
    let existingTag = tags.filter { $0.name.caseInsensitiveCompare(currentTag) == .orderedSame }.first ?? nil
    addTag(name,existingTag, context)
}

func handleNewNoteInput(_ currentTag: String,_ tags: [TreeNode], _ name: String, _ context: ModelContext) {
    addNote(currentTag,name,context, tags)
}

func handleShortcutInput(_ url: URL,_ tags: [TreeNode], _ context: ModelContext) {
    let input = url.queryParameters![INPUT_LABEL]!.components(separatedBy:"_")
    addNote(input[0], input[1], context, tags)
    switch url.host() {
    case nil:
        print("generic host")
    default:
        print("other host")
        break
    }
}
