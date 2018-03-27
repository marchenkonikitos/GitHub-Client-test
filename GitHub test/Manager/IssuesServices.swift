//
//  IssuesServices.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya

class IssuesService {
    private let provider = MoyaProvider<IssuesTarget>()
    private let variable = Variables()
    private let issues = IssuesStorage()
    
    func getIssues(repository: Repository, success: @escaping () -> Void, failed: @escaping (String) -> Void) {
        provider.request(.getIssues(username: variable.login, repos: repository.name!)) { response in
            if let value = response.value, value.statusCode == 200 {
                let data = value.data
                self.issues.clear()
                
                do {
                    let issuesData = try JSONDecoder().decode([IssueData].self, from: data)
                    DispatchQueue.main.async {
                        self.issues.save(issues: issuesData, repository: repository)
                        
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
    
    func loadIssues() -> [Issues] {
        return issues.load()
    }
}
