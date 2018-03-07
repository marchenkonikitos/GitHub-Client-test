//
//  IssueData.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 04.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation

struct IssueData: Decodable {
    let comments_url: String
    let title: String
    let comments: Int32
    let state: String
    let url: String
}
