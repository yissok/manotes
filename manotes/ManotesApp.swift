
import SwiftUI
import SwiftData


@main
struct manotesApp: App {
//    let a=aaa()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(AppDependencies.shared.myModelContainer)
    }
}


private func aaa() ->String{
    
        let context = ModelContext(AppDependencies.shared.myModelContainer)
    let text = "NOENC_app_"+"app sooomeeeeeee".base64Encoded!
        let trees = loadTrees(modelContext: context)
        printTreeNodeNames(treeNodes: trees)
//        let timeInterval = Date().timeIntervalSince1970
//        print("Time in seconds: \(Int(timeInterval))")
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy_HH-mm-ss"
        dateFormatter.timeZone = TimeZone.current
    let noteName = dateFormatter.string(from: Date())
        
        handleShortcutInput(text, trees, context, noteDate: noteName)
    return "aaaa"
}
private func loadTrees(modelContext: ModelContext) -> [TreeNode] {
    let fetchDescriptor = FetchDescriptor<TreeNode>()
    
    do {
         return try modelContext.fetch(fetchDescriptor)
    } catch let error {
        print(error.localizedDescription)
         // Error handling here or make the function throw
    }
    return []
}
