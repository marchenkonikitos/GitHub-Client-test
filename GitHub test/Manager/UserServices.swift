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
    
    var isAuth: Bool {
        get {
            return user.getUserLogin() != ""
        }
    }
    
    private func getUserViaHash(hash: String, success: @escaping () -> Void, failed: @escaping () -> Void) {
        provider.request(.getUser(hash: hash)) { response in
            
            do {
                _ = try response.value?.filterSuccessfulStatusCodes()
                let value = response.value!
                
                let data = value.data
                
                let userData = try JSONDecoder().decode(UserData.self, from: data)
                self.user.saveUserData(userData: userData)
                success()
            } catch {
                failed()
            }
        }
    }
    
    func login(username: String, password: String, success: @escaping () -> Void, failed: @escaping () -> Void) {
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        self.user.saveUser(hash: base64Credentials)
        
        getUserViaHash(hash: base64Credentials, success: {
            success()
        }) {
            failed()
        }
    }
    
    func getUser(success: @escaping () -> Void, failed: @escaping () -> Void) {
        let login = user.getUserLogin()
        
        getUserViaHash(hash: login, success: {
            success()
        }, failed: {
            failed()
        })
    }
    
    func getAvatar() -> NSData? {
        let imageURL = URL(string: UserDefaults.standard.value(forKey: "avatar_url") as! String)
        let data = NSData(contentsOf: imageURL!)
        
        return data
    }
    
    func logOut(){
        user.delete()
    }
}
