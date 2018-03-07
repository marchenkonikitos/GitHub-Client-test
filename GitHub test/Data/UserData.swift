//
//  UserData.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 01.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

struct UserData: Decodable {
    let id: Int
    let avatar_url: String
    let login: String
    let url: String
    let gists_url: String
    let repos_url: String
    let name: String
    let public_repos: Int
}
