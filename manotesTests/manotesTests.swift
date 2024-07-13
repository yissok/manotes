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
        func reset() {
            do {
                try modelContext.delete(model: TreeNode.self)
            } catch {
                print("Failed to delete students.")
            }
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
        print("\n\n\n\n\n")
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TreeNode.self, configurations: config)

        var sut = ContentView.ViewModel(modelContext: container.mainContext)
        
        var root = TreeNode(content: nil, name: LB_ROOT, parent: nil)
        sut.add(newNode: root)
        
        let nintendo = TreeNode(content: nil, name: "Nintendo", parent: root)
        root.children!.append(contentsOf: [nintendo])
        sut.add(newNode: nintendo)
        
        let smash = TreeNode(content: nil, name: "Smash", parent: nintendo)
        let zelda = TreeNode(content: nil, name: "Zelda", parent: nintendo)
        nintendo.children!.append(contentsOf: [smash, zelda])
        sut.add(newNode: smash)
        sut.add(newNode: zelda)
        
        let link = TreeNode(content: nil, name: "Link", parent: zelda)
        zelda.children!.append(link)
        sut.add(newNode: link)
        
        let sword = TreeNode(content: "iamasword", name: "1234567", parent: link)
        link.children!.append(sword)
        sut.add(newNode: sword)
        
        XCTAssertEqual(sut.fetchData().count, 6)
        
        var result = TreeNode.serialise(root)
        XCTAssertEqual(result, "ROOT-Nintendo-Smash-_-Zelda-Link-1234567:iamasword-_-_-_-")
        print("asserted 1")
        sut.reset()
        sut = ContentView.ViewModel(modelContext: container.mainContext)
        var nodesGlobal:[TreeNode]=[]
        root = TreeNode(content: nil, name: LB_ROOT, parent: nil)
        sut.add(newNode: root)
        nodesGlobal.append(root)
        
        
        TreeNode.insertTree(result, nodesGlobal, context: container.mainContext)
        
        let expected="""
||||||||||||||||||||||||||||||||||||||
Node: 1234567
Parent: Link
content: iamasword
Node: Link
Parent: Zelda
Node: Nintendo
Parent: ROOT
Node: ROOT
Parent: None
Node: Smash
Parent: Nintendo
Node: Zelda
Parent: Nintendo
______________________________________

"""
        XCTAssertEqual(strTreeNodeNames(treeNodes: sut.fetchData()), expected)
        print("asserted 2")
        print("\n\n\n\n\n")
    }
    
    func strTreeNodeNames(treeNodes: [TreeNode]) -> String {
        var str:String=""
        str.append("||||||||||||||||||||||||||||||||||||||\n") // Add newline for better readability
        for node in treeNodes {
            str.append(printTreeNodeDetails(node: node))
        }
        str.append("______________________________________\n") // Add newline for better readability
        return str
    }
    func printTreeNodeDetails(node: TreeNode) -> String {
        var str:String=""
        str.append("Node: \(node.name)\n")
        
        if let parent = node.parent {
            str.append("Parent: \(parent.name)\n")
        } else {
            str.append("Parent: None\n")
        }
        
        if node.content != nil
        {
            str.append("content: \(node.content ?? "none")\n")
        }
        return str
    }
}
