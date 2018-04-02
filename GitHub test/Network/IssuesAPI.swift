//
//  IssuesAPI.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya

enum IssuesTarget {
    case getIssues(username: String, repos: String)
    case createIssue(username: String, repos: String, title: String, body: String)
    case changeStatus(username: String, repos: String, number: Int)
}

extension IssuesTarget: TargetType, AccessTokenAuthorizable {
    
    var authorizationType: AuthorizationType {
        return .basic
    }
    
    var path: String {
        switch self {
        case .getIssues(let name, let repository):
            return "/repos/\(name)/\(repository)/issues"
        case .createIssue(let name, let repository, _, _):
            return "/repos/\(name)/\(repository)/issues"
        case .changeStatus(let name, let repository, let number):
            return "/repos/\(name)/\(repository)/issues/\(number)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getIssues:
            return .get
        case .createIssue:
            return .post
        case .changeStatus:
            return .patch
        }
    }
    
    var task: Task {
        switch self{
        case .getIssues:
            return .requestPlain
        case .createIssue(_, _, let title, let body):
            return .requestParameters(parameters: ["title": title, "body": body], encoding: JSONEncoding.default)
        case .changeStatus(_, _, _):
            return .requestParameters(parameters: ["state": "close"], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
