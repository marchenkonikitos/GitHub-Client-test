//
//  RepositoriesServices.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya

class RepositoryServices {
    
    private let provider = MoyaProvider<RepositoriesTarget>()
    private let variable = Variables()
    private let repositories = RepositoriesStorage()
    
    func getRepositories(success: @escaping () -> Void, failed: @escaping (String) -> Void) {
        provider.request(.getRepositories(username: variable.login)) { response in
            do {
                _ = try response.value?.filterSuccessfulStatusCodes()
                let value = response.value!
                let data = value.data
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.newBackgroundContext()
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey(rawValue: "context")!] = context
                
                _ = try JSONDecoder().decode([Repository].self, from: data)
                self.repositories.clear()
                saveData(context: context)
                success()
            } catch {
                if let err = response.error?.localizedDescription {
                    failed(err)
                } else {
                    failed("So big problem")
                }
            }
        }
    }
    
    func loadRepos() -> [Repository]{
        return repositories.load()
    }
}
