//
//  IssuesStorage.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import CoreData

class IssuesStorage {
    func save(issues: [IssueData], repository: Repository) {
        issues.forEach { (issue) in
            let context = getContext()
            let issueObj = Issues(entity: Issues.entity(), insertInto: context)
//            let issueObj = NSEntityDescription.insertNewObject(forEntityName: "Issues", into: context) as! Issues
            
            issueObj.title = issue.title
            issueObj.comments = issue.comments
            issueObj.state = issue.state
            issueObj.url = issue.url
            issueObj.number = Int32(issue.number)
            issueObj.repository = repository
            
            saveData(context: context)
        }
    }
    
    func clear() {
        guard clearIssues() else { return }
    }
    
    func load() -> [Issues]{
        return loadIssues()
    }
}
