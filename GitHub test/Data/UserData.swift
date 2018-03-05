//
//  UserData.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 01.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

struct UserData: Decodable {
    var id: Int
    var avatar_url: String
    var login: String
    var url: String
    var gists_url: String
    var repos_url: String
    var name: String
    var public_repos: Int
}
