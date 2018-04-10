//
//  CommentsServices.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import Swinject

class CommentsServices {
    private let provider: MoyaProvider<CommentTarget>
    private let variable: Variables
    private let storage: CommentsStorage
    
    init(variable: Variables, storage: CommentsStorage, provider: MoyaProvider<CommentTarget>) {
        self.variable = variable
        self.storage = storage
        self.provider = provider
    }
    
    func getComments(repository: String, issue: Issues) ->  Promise<Void>{
        storage.clear()
        return provider.request(.getComments(username: variable.login, repository: repository, number: Int(issue.number))).compactMap({ response -> [Comments] in
            try JSONDecoder().decode([Comments].self, from: response.data)
        }).asVoid()
    }
    
    func loadIssues() -> [Comments] {
        return storage.load()
    }
}
