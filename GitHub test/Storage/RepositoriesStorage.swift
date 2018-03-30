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
    
    func clear() {
        guard clearRepositories() else { return}
    }
    
    func load() -> [Repository]{
        return loadRepositories()
    }
}
