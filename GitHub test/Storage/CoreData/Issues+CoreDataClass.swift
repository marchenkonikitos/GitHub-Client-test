//
//  Issues+CoreDataClass.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 28.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Issues)
public class Issues: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case comments
        case state
        case url
        case number
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Issues", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)!
        self.comments = (try container.decodeIfPresent(Int32.self, forKey: .comments))!
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.url = (try container.decodeIfPresent(String.self, forKey: .url))!
        self.number = (try container.decodeIfPresent(Int32.self, forKey: .number))!
        
        try context.save()
    }
}
