//
//  Moya+Extencion.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 22.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya

enum IssuesServices {
    case getIssues(username: String, repos: String)
}

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
