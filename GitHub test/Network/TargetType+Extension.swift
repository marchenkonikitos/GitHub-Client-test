//
//  TargetType+Extension.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 27.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}

extension NSManagedObjectContext {
    static let context = CodingUserInfoKey(rawValue: "context")
}
