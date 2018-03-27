//
//  IssueData.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 04.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation

struct IssueData: Decodable {
    let commentsUrl: String
    let title: String
    let comments: Int32
    let state: String
    let url: String
    let number: Int
    
    enum CodingKeys: String, CodingKey {
        case commentsUrl = "comments_url"
        case title
        case comments
        case state
        case url
        case number
    }
}
