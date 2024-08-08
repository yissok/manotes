//
//  TreeNodeEntity+CoreDataClass.swift
//  manotes
//
//  Created by andrea on 07/08/24.
//
//

import Foundation
import CoreData

@objc(TreeNodeEntity)
public class TreeNodeEntity: NSManagedObject {

}

//extension TreeNodeEntity {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<TreeNodeEntity> {
//        return NSFetchRequest<TreeNodeEntity>(entityName: "TreeNodeEntity")
//    }
//
//    @NSManaged public var id: String?
//    @NSManaged public var name: String?
//    @NSManaged public var content: String?
//    @NSManaged public var enc: Bool
//    @NSManaged public var parent: TreeNodeEntity?
//    @NSManaged public var children: NSSet<TreeNodeEntity>?
//}

// MARK: Generated accessors for children
extension TreeNodeEntity {
    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: TreeNodeEntity)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: TreeNodeEntity)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)
}

