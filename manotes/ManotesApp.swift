import SwiftUI
import SwiftData

@main
struct manotesApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [TreeNode.self])
    }
}
