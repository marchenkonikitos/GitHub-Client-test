//
//  RepositoriesStorage.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import CoreData

class RepositoriesStorage {
    func save(repositories: [Repository]) {
        repositories.forEach { (repository) in
            let context = getContext()
            let entityDescription = NSEntityDescription.entity(forEntityName: "Repository", in: context)!
            let repos = Repository.init(entity: entityDescription, insertInto: context)
            
            repos.id = repository.id
            repos.name = repository.name
            repos.url = repository.url
            repos.hasIssues = repository.hasIssues
            repos.htmlUrl = repository.htmlUrl
            repos.openIssuesCount = repository.openIssuesCount
            
            saveData(context: context)
        }
    }
    
    func clear() {
        guard clearRepositories() else { return}
    }
    
    func load() -> [Repository]{
        return loadRepositories()
    }
}
