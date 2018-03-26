//
//  Moya+Extencion.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 22.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya

enum RepositoriesServices {
    case getRepositories(username: String)
}

enum IssuesServices {
    case getIssues(username: String, repos: String)
}

enum CommentServices {
    case getComments(username: String, repository: String, number: Int)
}

//MARK: Repositories

extension RepositoriesServices: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .getRepositories(let name):
            return "/users/\(name)/repos"
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
        case .getRepositories(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

//MARK: -Issues
extension IssuesServices: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .getIssues(let name, let repository):
            return "/repos/\(name)/\(repository)/issues"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self{
        case .getIssues(_, _):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}

//MARK: -Comments
extension CommentServices: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
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
        case .getComments(_, _, _):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}

