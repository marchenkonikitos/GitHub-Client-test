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
    let has_issues: Bool
    let html_url: String
    let open_issues_count: Int32
}
