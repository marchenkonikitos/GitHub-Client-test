//
//  Repository+CoreDataClass.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 28.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Repository)
public class Repository: NSManagedObject, Codable {
    
    required convenience public init(from decoder: Decoder) throws {
        let context = getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Repository", in: context)!
        
        self.init(entity: entityDescription, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //self.hasIssues = container.decodeIfPresent(String.self, forKey: .)
    }
}
