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

class CommentsServices {
    private let provider = MoyaProvider<CommentTarget>()
    private let variable = Variables()
    private let comments = CommentsStorage()
    
    func getComments(repository: String, issue: Issues) ->  Promise<Void>{
        comments.clear()
        return provider.request(.getComments(username: variable.login, repository: repository, number: Int(issue.number))).compactMap({ response -> [Comments] in
            try JSONDecoder().decode([Comments].self, from: response.data)
        }).done({ issue in
            //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //            let context = appDelegate.persistentContainer.newBackgroundContext()
            //
            //            self.issues.clear()
            //            saveData(context: context)
        })
    }
    
    func loadIssues() -> [Comments] {
        return comments.load()
    }
}









enum TestError: Error {
    case wrongInt
}

class Test {
    
    func getStrFromRemote(a: Int) -> Promise<String> {
        return Promise<String> { seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                if a > 0 {
                    seal.fulfill("1234")
                } else {
                    seal.reject(TestError.wrongInt)
                }
            })
        }
    }
    
    func getStrFromRemoteWithPending(a: Int) -> Promise<String> {
        let pending = Promise<String>.pending()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            if a > 0 {
                pending.resolver.fulfill("1234")
            } else {
                pending.resolver.reject(TestError.wrongInt)
            }
        })
        return pending.promise
    }
    
    func test() {
        firstly {
            self.getStrFromRemoteWithPending(a: 4)
        }.then { str in
            self.getStrFromRemote(a: 0)
        }.done { str in
            print(str)
        }.catch { err in
            print(err.localizedDescription)
        }
    }
}
