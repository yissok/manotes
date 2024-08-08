

import Foundation
import SwiftData
final class AppDependencies {
    static let shared = AppDependencies()

    private init() {}

    let myModelContainer: ModelContainer = {
        let schema = Schema([TreeNode.self])
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.note.buds")!
        let storeURL = containerURL.appendingPathComponent("ModelContainer.sqlite")

        let configuration = ModelConfiguration(url: storeURL)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch let error {
            fatalError("cannot set up modelContainer: \(error.localizedDescription)")
        }
    }()
}
