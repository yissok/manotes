import Foundation
import CoreData
import SwiftData
import Intents
import AppIntents


class InputIntentHandler: NSObject, InputIntentHandling {
    
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer = AppDependencies.shared.myModelContainer) {
        self.modelContainer = modelContainer
    }

    
    func resolveInp(for intent: InputIntent, with completion: @escaping (InputInpResolutionResult) -> Void) {
        
        if let text = intent.inp, !text.isEmpty {
            completion(InputInpResolutionResult.success(with: text))
        } else {
            completion(InputInpResolutionResult.unsupported(forReason: .noText))
        }
        
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
    
    @MainActor func handle(intent: InputIntent, completion: @escaping (InputIntentResponse) -> Void) {
        print("intenttttttttttInputIntentHandlerInputIntentHandlerInputIntentHandler")
//        let context = DataController.shared.context
//
//        
//        handleShortcutInput("aaaa", nodesGlobal, containerSUI.mainContext, noteDate: "1722969113881")
        let context = ModelContext(modelContainer)
        
        let firstWord = intent.inp!.components(separatedBy: " ").first
        let text = "NOENC_\(firstWord ?? "nun")_"+intent.inp!.base64Encoded!
        let trees = loadTrees(modelContext: context)
        printTreeNodeNames(treeNodes: trees)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy_HH-mm-ss"
        dateFormatter.timeZone = TimeZone.current
    let noteName = dateFormatter.string(from: Date())
        
        handleShortcutInput(text, trees, context, noteDate: noteName)
        completion(.success(tagfolder: "thoughtsorsumn"))
    }
}
