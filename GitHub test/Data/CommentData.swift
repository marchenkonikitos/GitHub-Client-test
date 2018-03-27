//
//  CommentData.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 07.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation

struct CommentData: Decodable {
    let body: String
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case body
        case htmlUrl = "html_url"
    }
}
