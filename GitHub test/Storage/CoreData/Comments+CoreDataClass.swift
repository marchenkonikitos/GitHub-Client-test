//
//  Comments+CoreDataClass.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 28.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//
//

import Foundation
import CoreData


@objc(Comments)
public class Comments: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case body
        case htmlUrl = "html_url"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Comments", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
        self.htmlUrl = (try container.decodeIfPresent(String.self, forKey: .htmlUrl))!
        
        try context.save()
    }
}
