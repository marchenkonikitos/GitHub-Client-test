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
    
    func clear() {
        guard clearIssues() else { return }
    }
    
    func load() -> [Issues]{
        return loadIssues()
    }
}
