//
//  TreeNodeEntity+CoreDataProperties.swift
//  manotes
//
//  Created by andrea on 07/08/24.
//
//

import Foundation
import CoreData


extension TreeNodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TreeNodeEntity> {
        return NSFetchRequest<TreeNodeEntity>(entityName: "TreeNodeEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var content: String?
    @NSManaged public var enc: Bool
    @NSManaged public var parent: TreeNodeEntity?
    @NSManaged public var children: TreeNodeEntity?

}

extension TreeNodeEntity : Identifiable {

}
