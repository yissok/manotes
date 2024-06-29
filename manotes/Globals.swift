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
