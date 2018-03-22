//
//  UserData.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 01.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

struct UserData: Decodable {
    let id: Int
    let avatarUrl: String
    let login: String
    let url: String
    let gistsUrl: String
    let reposUrl: String
    let name: String
    let publicRepos: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case avatarUrl = "avatar_url"
        case login
        case url
        case gistsUrl = "gists_url"
        case reposUrl = "repos_url"
        case name
        case publicRepos = "public_repos"
    }
}
