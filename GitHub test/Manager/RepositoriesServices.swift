//
//  RepositoriesServices.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

enum RepositoryServicesError {
    case wrongArg
}

class RepositoryServices {
    
    private let provider = MoyaProvider<RepositoriesTarget>()
    private let variable = Variables()
    private let repositories = RepositoriesStorage()
    
    func getRepositories() -> Promise<Void> {
        repositories.clear()
        return provider.request(.getRepositories(username: variable.login)).compactMap({ response in
            try JSONDecoder().decode([Repository].self, from: response.data)
        }).asVoid()
    }
    
    func loadRepos() -> [Repository]{
        return repositories.load()
    }
}
