//
//  CommentsServices.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya

class CommentsServices {
    private let provider = MoyaProvider<CommentTarget>()
    private let variable = Variables()
    private let comments = CommentsStorage()
    
    func getComments(repository: Repository, issue: Issues, success: @escaping () -> Void) {
        provider.request(.getComments(username: variable.login, repository: repository.name!, number: Int(issue.number))) { response in
            if let value = response.value, value.statusCode == 200 {
                let data = value.data
                
                do {
                    let commentsData = try JSONDecoder().decode([CommentData].self, from: data)
                    DispatchQueue.main.async {
                        self.comments.clear()
                        self.comments.save(comments: commentsData, issue: issue)
                        
                        success()
                    }
                } catch {
                }
            }
        }
    }
    
    func loadIssues() -> [Comments] {
        return comments.load()
    }
}
