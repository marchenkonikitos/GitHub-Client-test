//
//  UserStorage.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import KeychainSwift

protocol UserProtocol {
    func saveUser(hash: String)
    func saveUserData(userData: UserData)
    func getUserLogin() -> String
    func delete()
}

class UserStorage : UserProtocol {
    private let keyChain = KeychainSwift()
    
    func saveUser(hash: String) {
        self.keyChain.set(hash, forKey: "base64Credentials")
    }
    
    func saveUserData(userData: UserData) {
        UserDefaults.standard.set(userData.id, forKey: "userId")
        UserDefaults.standard.set(userData.avatarUrl, forKey: "avatar_url")
        UserDefaults.standard.set(userData.login, forKey: "login")
        UserDefaults.standard.set(userData.url, forKey: "userUrl")
        UserDefaults.standard.set(userData.gistsUrl, forKey: "gists_url")
        UserDefaults.standard.set(userData.reposUrl, forKey: "repos_url")
        UserDefaults.standard.set(userData.name, forKey: "userName")
        UserDefaults.standard.set(userData.publicRepos, forKey: "numberOfRepos")
    }
    
    func getUserLogin() -> String {
        if let hash = keyChain.get("base64Credentials") {
            return hash
        }
        return ""
    }
    
    func delete() {
        self.keyChain.clear()
    }
}
