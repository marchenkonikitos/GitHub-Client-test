//
//  Repository+CoreDataProperties.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 28.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Repository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repository> {
        return NSFetchRequest<Repository>(entityName: "Repository")
    }

    @NSManaged public var hasIssues: Bool
    @NSManaged public var htmlUrl: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var openIssuesCount: Int32
    @NSManaged public var url: String?
    @NSManaged public var issues: NSSet?

}

// MARK: Generated accessors for issues
extension Repository {

    @objc(addIssuesObject:)
    @NSManaged public func addToIssues(_ value: Issues)

    @objc(removeIssuesObject:)
    @NSManaged public func removeFromIssues(_ value: Issues)

    @objc(addIssues:)
    @NSManaged public func addToIssues(_ values: NSSet)

    @objc(removeIssues:)
    @NSManaged public func removeFromIssues(_ values: NSSet)

}
