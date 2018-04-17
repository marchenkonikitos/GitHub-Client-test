//
//  UserServices.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import Swinject

enum UserErrors: Error {
    case wrondData
}

protocol UserServices {
    var isAuth: Bool { get }
    func getData(_ hash: String) -> Promise<Void>
    func login(username: String, password: String) -> Promise<Void>
    func getAvatar() -> NSData?
    func logOut()
}

class UserServicesRealisation: UserServices {
    
    private let provider: MoyaProvider<UserTarget>
    private let storage: UserStorage
    
    var isAuth: Bool {
        return storage.getUserLogin() != ""
    }
    
    init(provider: MoyaProvider<UserTarget>, storage: UserStorage) {
        self.provider = provider
        self.storage = storage
    }
    
    func getData(_ hash: String) -> Promise<Void> {
        return provider.request(.getUser(hash: hash))
            .compactMap({ response -> UserData in
                try JSONDecoder().decode(UserData.self, from: response.data)
            }).done { user in
                self.storage.saveUserData(userData: user)
        }
    }
    
    func login(username: String, password: String) -> Promise<Void> {
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        return getData(base64Credentials).done {_ in
            self.storage.saveUser(hash: base64Credentials)
        }
    }
    
    func getAvatar() -> NSData? {
        let imageURL = URL(string: UserDefaults.standard.value(forKey: "avatar_url") as! String)
        let data = NSData(contentsOf: imageURL!)
        
        return data
    }
    
    func logOut() {
        storage.delete()
    }
}
