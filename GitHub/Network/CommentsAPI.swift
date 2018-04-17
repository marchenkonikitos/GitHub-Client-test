//
//  CommentsAPI.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya

enum CommentTarget {
    case getComments(username: String, repository: String, number: Int)
}

extension CommentTarget: TargetType {
    
    var path: String {
        switch self {
        case .getComments(let name, let repository, let number):
            return "/repos/\(name)/\(repository)/issues/\(number)/comments"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self{
        case .getComments:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
