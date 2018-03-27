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
            if let value = response.value, value.statusCode == 200 {
                let data = value.data
                
                do {
                    let reposData = try JSONDecoder().decode([ReposData].self, from: data)
                    DispatchQueue.main.async {
                        self.repositories.clear()
                        self.repositories.save(repositories: reposData)
                        
                        success()
                    }
                } catch {
                    if let err = response.error?.localizedDescription {
                        failed(err)
                    } else {
                        failed("So big problem")
                    }
                }
            } else {
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
