//
//  UserServices.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya

class UserServices {
    
    private let provider = MoyaProvider<UserTarget>()
    private let user = UserStorage()
    
    private func getUser(hash: String, success: @escaping () -> Void, failed: @escaping () -> Void) {
        provider.request(.getUser(hash: hash)) { response in
            
            if let value = response.value, value.statusCode == 200 {
                let data = value.data
                
                do {
                    let userData = try JSONDecoder().decode(UserData.self, from: data)
                    DispatchQueue.main.async {
                        self.user.saveUserData(userData: userData)
                        success()
                    }
                } catch {
                    failed()
                }
            
            } else {
                failed()
            }
        }
    }
    
    func login(username: String, password: String, success: @escaping () -> Void, failed: @escaping () -> Void) {
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        self.user.saveUser(hash: base64Credentials)
        
        getUser(hash: base64Credentials, success: {
            success()
        }) {
            failed()
        }
    }
    
    func getUserLogin(success: () -> Void) {
        let login = user.getUserLogin()
        
        if login != "" {
            success()
        }
    }
    
    func imageData() -> NSData {
        let imageURL = URL(string: UserDefaults.standard.value(forKey: "avatar_url") as! String)
        let data = NSData(contentsOf: imageURL!)
        
        return data!
    }
}
