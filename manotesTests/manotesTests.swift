import XCTest
@testable import manotes
import SwiftData
import SwiftUI

extension ContentView {
    @Observable
    final class ViewModel {
        private let modelContext: ModelContext
        private(set) var trees = [TreeNode]()
        
        
        
        func add(newNode: TreeNode) {
            modelContext.insert(newNode)
            try? modelContext.save()
        }
        func save() {
            try? modelContext.save()
        }
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }

        func fetchData() -> [TreeNode]{
            do {
                let descriptor = FetchDescriptor<TreeNode>(sortBy: [SortDescriptor(\.name)])
                return try modelContext.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
            return []
        }
    }
}
struct ContentView: View {
    @State private var viewModel: ViewModel

    var body: some View {
        NavigationStack {
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

final class manotesTests: XCTestCase {
    var container: ModelContainer!
    
    
    @MainActor func testTreeNodeInitialization()  throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TreeNode.self, configurations: config)

        let sut = ContentView.ViewModel(modelContext: container.mainContext)

//        let context = container.viewContext
        let root = TreeNode(content: "Root Content", name: "Root", parent: nil)
        sut.add(newNode: root)
        
        let child1 = TreeNode(content: "Child 1 Content", name: "Child 1", parent: root)
        let child2 = TreeNode(content: "Child 2 Content", name: "Child 2", parent: root)
        root.children.append(contentsOf: [child1, child2])
        sut.add(newNode: child1)
        sut.add(newNode: child2)
        
        let child1_1 = TreeNode(content: "Child 1.1 Content", name: "Child 1.1", parent: child1)
        let child1_2 = TreeNode(content: "Child 1.2 Content", name: "Child 1.2", parent: child1)
        child1.children.append(contentsOf: [child1_1, child1_2])
        sut.add(newNode: child1_1)
        sut.add(newNode: child1_2)
        
        let child2_1 = TreeNode(content: "Child 2.1 Content", name: "Child 2.1", parent: child2)
        let child2_2 = TreeNode(content: "Child 2.2 Content", name: "Child 2.2", parent: child2)
        child2.children.append(contentsOf: [child2_1, child2_2])
        sut.add(newNode: child2_1)
        sut.add(newNode: child2_2)
        
        let child1_1_1 = TreeNode(content: "Child 1.1.1 Content", name: "Child 1.1.1", parent: child1_1)
        child1_1.children.append(child1_1_1)
        sut.add(newNode: child1_1_1)
        
        XCTAssertEqual(sut.fetchData().count, 8)
        
        
        func printTree(node: TreeNode, level: Int = 0) {
            let indent = String(repeating: "  ", count: level)
            print("\(indent)\(node.name) (id: \(node.id))")
            if let content = node.content {
                print("\(indent)  Content: \(content)")
            }
            for child in node.children {
                printTree(node: child, level: level + 1)
            }
        }

        printTree(node: root)
        
        let result = TreeNode.getSingleBranchTree(root)
        XCTAssertEqual(result, "a", "The getSingleBranchTree method should return 'a'")
    }
}

        // Adding children to the first child of the root
//        let child1_1 = TreeNode(content: "Child 1.1 content", name: "Child 1.1", parent: child1)
//        let child1_2 = TreeNode(content: "Child 1.2 content", name: "Child 1.2", parent: child1)
//        child1.children.append(child1_1)
//        try context.save()
//        child1.children.append(child1_2)
//        try context.save()
//
//        // Adding children to the second child of the root
//        let child2_1 = TreeNode(content: "Child 2.1 content", name: "Child 2.1", parent: child2)
//        let child2_2 = TreeNode(content: "Child 2.2 content", name: "Child 2.2", parent: child2)
//        child2.children.append(child2_1)
//        try context.save()
//        child2.children.append(child2_2)
//        try context.save()
