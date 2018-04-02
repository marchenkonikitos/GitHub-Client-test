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

class IssuesService {
    private let provider = MoyaProvider<IssuesTarget>()
    private let variable = Variables()
    private let issues = IssuesStorage()
    
    func getIssues(repository: Repository) -> Promise<Void> {
        issues.clear()
        return provider.request(.getIssues(username: variable.login, repos: repository.name!)).compactMap({ response -> [Issues] in
            try JSONDecoder().decode([Issues].self, from: response.data)
        }).done({ issue in
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.newBackgroundContext()
//            
//            self.issues.clear()
//            saveData(context: context)
        })
    }
    
//    func createIssue() -> Promise<Void> {
//        
//    }
    
    func loadIssues() -> [Issues] {
        return issues.load()
    }
}
