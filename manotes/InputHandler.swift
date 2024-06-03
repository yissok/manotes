import Foundation
import SwiftData


func handleInput(_ url: URL, _ context: ModelContext) {
    let input = url.queryParameters![INPUT_LABEL]!
    addItem(input, context)
    switch url.host() {
    case nil:
        print("generic host")
    default:
        print("other host")
        break
    }
}
