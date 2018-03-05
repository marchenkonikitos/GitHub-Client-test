//
//  Issues+CoreDataProperties.swift
//  
//
//  Created by Nikita Marchenko on 04.03.2018.
//
//

import Foundation
import CoreData


extension Issues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Issues> {
        return NSFetchRequest<Issues>(entityName: "Issues")
    }

    @NSManaged public var comments_url: String?
    @NSManaged public var title: String?
    @NSManaged public var comments: Int32
    @NSManaged public var state: String?
    @NSManaged public var repository: Repository?

}
