//
//  Issues+CoreDataProperties.swift
//  
//
//  Created by Nikita Marchenko on 07.03.2018.
//
//

import Foundation
import CoreData


extension Issues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Issues> {
        return NSFetchRequest<Issues>(entityName: "Issues")
    }

    @NSManaged public var comments: Int32
    @NSManaged public var commentsUrl: String?
    @NSManaged public var state: String?
    @NSManaged public var title: String?
    @NSManaged public var repository: Repository?
    @NSManaged public var comment: Comments?
    @NSManaged public var url: String?
    @NSManaged public var number: Int32?

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
