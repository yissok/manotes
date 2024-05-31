//
//  manotesApp.swift
//  manotes
//
//  Created by andrea on 30/05/24.
//

import SwiftUI
import SwiftData

@main
struct manotesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { (url) in
                let decoded = url.absoluteString.replacingOccurrences(of: "\(appNameUrl)://?result=", with: "").decodeUrl()!
                print("modifiedString: "+decoded)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
