//
//  CommentsStorage.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import CoreData

class CommentsStorage {
    
    func clear() {
        guard clearComments() else { return }
    }
    
    func load() -> [Comments]{
        return loadComments()
    }
}
