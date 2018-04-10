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
import Swinject

enum RepositoryServicesError {
    case wrongArg
}

class RepositoryServices {
    
    private let provider: MoyaProvider<RepositoriesTarget>
    private let variable: Variables
    private let storage: RepositoriesStorage
    
    init(provider: MoyaProvider<RepositoriesTarget>, variable: Variables, storage: RepositoriesStorage) {
        self.provider = provider
        self.variable = variable
        self.storage = storage
    }
    
    func getRepositories() -> Promise<Void> {
        storage.clear()
        return provider.request(.getRepositories(username: variable.login)).compactMap({ response in
            try JSONDecoder().decode([Repository].self, from: response.data)
            JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase
        }).asVoid()
    }
    
    func loadRepos() -> [Repository]{
        return storage.load()
    }
}
