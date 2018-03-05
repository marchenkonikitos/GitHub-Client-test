//
//  ReposData.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 02.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation

struct ReposData: Decodable {
    var id: Int32
    var name: String
    var url: String
    var has_issues: Bool
    var html_url: String
    var open_issues_count: Int32
}
