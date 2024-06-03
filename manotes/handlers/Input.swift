import Foundation
import SwiftData


func handleNewTagInput(_ name: String, _ context: ModelContext) {
    addTag(name, context)
}

func handleShortcutInput(_ url: URL, _ context: ModelContext) {
    let input = url.queryParameters![INPUT_LABEL]!.components(separatedBy:"_")
    addNote(input[0], input[1], context)
    switch url.host() {
    case nil:
        print("generic host")
    default:
        print("other host")
        break
    }
}
