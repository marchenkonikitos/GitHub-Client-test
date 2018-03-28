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
public class Repository: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case hasIssues = "has_issues"
        case htmlUrl = "html_url"
        case openIssuesCount = "open_issues_count"
    }

    required convenience public init(from decoder: Decoder) throws {
        let context = getContext()
    
        
//        guard let context = decoder.userInfo[CodingUserInfoKey(rawValue: "context")!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Repository", in: context) else { fatalError() }

        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int32.self, forKey: .id)!
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.hasIssues = (try container.decodeIfPresent(Bool.self, forKey: .hasIssues))!
        self.htmlUrl = try container.decodeIfPresent(String.self, forKey: .htmlUrl)
        self.openIssuesCount = (try container.decodeIfPresent(Int32.self, forKey: .openIssuesCount))!
    }
}
