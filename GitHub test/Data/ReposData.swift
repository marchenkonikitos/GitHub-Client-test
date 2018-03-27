//
//  ReposData.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 02.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation

struct ReposData: Decodable {
    let id: Int32
    let name: String
    let url: String
    let hasIssues: Bool
    let htmlUrl: String
    let openIssuesCount: Int32
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case hasIssues = "has_issues"
        case htmlUrl = "html_url"
        case openIssuesCount = "open_issues_count"
    }
}
