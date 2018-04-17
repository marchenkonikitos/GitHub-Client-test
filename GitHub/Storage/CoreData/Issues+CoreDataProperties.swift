//
//  Issues+CoreDataProperties.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 28.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Issues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Issues> {
        return NSFetchRequest<Issues>(entityName: "Issues")
    }

    @NSManaged public var comments: Int32
    @NSManaged public var number: Int32
    @NSManaged public var state: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var comment: NSSet?
    @NSManaged public var repository: Repository?

}

// MARK: Generated accessors for comment
extension Issues {

    @objc(addCommentObject:)
    @NSManaged public func addToComment(_ value: Comments)

    @objc(removeCommentObject:)
    @NSManaged public func removeFromComment(_ value: Comments)

    @objc(addComment:)
    @NSManaged public func addToComment(_ values: NSSet)

    @objc(removeComment:)
    @NSManaged public func removeFromComment(_ values: NSSet)

}
