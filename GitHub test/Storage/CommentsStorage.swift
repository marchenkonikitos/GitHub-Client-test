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
    func save(comments: [CommentData], issue: Issues) {
        for comment in comments {
            let context = getContext()
            let commentObj = NSEntityDescription.insertNewObject(forEntityName: "Comments", into: context) as! Comments
            
            commentObj.body = comment.body
            commentObj.htmlUrl = comment.htmlUrl
            commentObj.issues = issue
            
            saveData(context: context)
        }
    }
    
    func clear() {
        guard clearComments() else { return }
    }
    
    func load() -> [Comments]{
        return loadComments()
    }
}
