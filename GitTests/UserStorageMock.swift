//
//  UserStorage.swift
//  GitTests
//
//  Created by Nikita Marchenko on 4/17/18.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

@testable import GitHub

class UserStorageMock : UserProtocol {
    var someUserHash: String = ""
    
    func saveUser(hash: String) {
        someUserHash = hash
    }
    
    func saveUserData(userData: UserData) {
        
    }
    
    func getUserLogin() -> String {
        return someUserHash
    }
    
    func delete() { }
    
    
}
