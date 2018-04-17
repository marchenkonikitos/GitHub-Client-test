//
//  IssuesServices.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import Swinject

class IssuesService {
    private var provider: MoyaProvider<IssuesTarget>
    private let variable: Variables
    private let storage: IssuesStorage
    
    init(variable: Variables, storage: IssuesStorage, provider: MoyaProvider<IssuesTarget>) {
        self.variable = variable
        self.storage = storage
        self.provider = provider
    }
    
    func getIssues(repository: Repository) -> Promise<Void> {
        storage.clear()
        return provider.request(.getIssues(username: variable.login, repos: repository.name!)).compactMap({ response in
            try JSONDecoder().decode([Issues].self, from: response.data)
        }).asVoid()
    }
    
    func createIssue(title: String, body: String, repository: String) -> Promise<Void> {
        return provider.request(.createIssue(username: variable.login, repos: repository, title: title, body: body)).done({ response in
            try _ = JSONDecoder().decode(Issues.self, from: response.data)
        }).asVoid()
    }
    
    func closeIssue(repository: String, number: Int) -> Promise<Void> {
        return provider.request(.changeStatus(username: variable.login, repos: repository, number: number)).asVoid()
    }
    
    func loadIssues() -> [Issues] {
        return storage.load()
    }
}
