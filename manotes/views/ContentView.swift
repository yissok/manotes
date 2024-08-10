import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context;
    var body: some View {
        let contextProvider = ContextProvider(context: context)
        return RootView()
            .environmentObject(contextProvider)
//            .environment(\.font, Font.custom("Courier", size: 14))
        
    }
}
