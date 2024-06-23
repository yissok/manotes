import XCTest
@testable import manotes

final class manotesTests: XCTestCase {

    override func setUpWithError() throws {}

    func testExample() throws {
        let treeNode = TreeNode(content: "", name: "", parent: nil)
        let result = TreeNode.getSingleBranchTree(treeNode)
        XCTAssertEqual(result, "a", "The getSingleBranchTree method should return 'a'")

    }

    override func tearDownWithError() throws {}
}
