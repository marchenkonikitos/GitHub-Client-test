//
//  Comments+CoreDataProperties.swift
//  
//
//  Created by Nikita Marchenko on 07.03.2018.
//
//

import Foundation
import CoreData


extension Comments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comments> {
        return NSFetchRequest<Comments>(entityName: "Comments")
    }

    @NSManaged public var body: String?
    @NSManaged public var html_url: String?
    @NSManaged public var issues: Issues?

}
