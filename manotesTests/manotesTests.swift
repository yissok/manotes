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


final class manotesTests: XCTestCase {
    var container: ModelContainer!
    
    
    @MainActor func testTreeNodeInitialization()  throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TreeNode.self, configurations: config)

        let sut = ContentView.ViewModel(modelContext: container.mainContext)

        let root = TreeNode(content: nil, name: "ROOT", parent: nil)
        sut.add(newNode: root)
        
        let nintendo = TreeNode(content: nil, name: "Nintendo", parent: root)
        root.children.append(contentsOf: [nintendo])
        sut.add(newNode: nintendo)
        
        let smash = TreeNode(content: nil, name: "Smash", parent: nintendo)
        let zelda = TreeNode(content: nil, name: "Zelda", parent: nintendo)
        nintendo.children.append(contentsOf: [smash, zelda])
        sut.add(newNode: smash)
        sut.add(newNode: zelda)
        
        let link = TreeNode(content: nil, name: "Link", parent: zelda)
        zelda.children.append(link)
        sut.add(newNode: link)
        
        let sword = TreeNode(content: "iamasword", name: "Sword", parent: link)
        link.children.append(sword)
        sut.add(newNode: sword)
        
        XCTAssertEqual(sut.fetchData().count, 6)
        
        
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
        
        var result = TreeNode.serialise(root)
        XCTAssertEqual(result, "ROOT-Nintendo-Smash-_-Zelda-Link-Sword:iamasword-_-_-_-")
    }
}
