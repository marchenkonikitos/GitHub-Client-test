//
//  UserAPI.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya

enum UserTarget {
    case getUser(hash: String)
}

extension UserTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .getUser(_):
            return "/user"
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
        case .getUser(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUser(let hash):
            let headers = ["Authorization": "Basic \(hash)"]
            
            return headers
        }
    }
}
