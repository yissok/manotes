import Foundation

let CONTENT_PASSED="CONTENT_PASSED"
let UN_ID="manotes_uniqueidddddd"
let APP_NAME_URL="manotesURL"
let SHORTCUT_NAME="manoteSHTCT"
let INPUT_LABEL="input"

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
