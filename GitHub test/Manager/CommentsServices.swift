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
    
    func getComments(repository: Repository, issue: Issues, success: @escaping () -> Void, failed: @escaping (String) -> Void) {
        provider.request(.getComments(username: variable.login, repository: repository.name!, number: Int(issue.number))) { response in
            
            do {
                _ = try response.value?.filterSuccessfulStatusCodes()
                let value = response.value!
                
                let data = value.data
                
                
                let commentsData = try JSONDecoder().decode([CommentData].self, from: data)
                
                self.comments.clear()
                self.comments.save(comments: commentsData, issue: issue)
                
                success()
                
            } catch {
                if let err = response.error?.localizedDescription {
                    failed(err)
                } else {
                    failed("So big problem")
                }
            }
        }
    }
    
    func loadIssues() -> [Comments] {
        return comments.load()
    }
}
