//
//  globals.swift
//  manotes
//
//  Created by andrea on 31/05/24.
//

import Foundation

let CONTENT_PASSED="CONTENT_PASSED"
let UN_ID="manotes_uniqueidddddd"
let appNameUrl="manotesURL"

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
