//
//  Variables.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 26.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation

class Variables {
    public var login: String = {
        return UserDefaults.standard.value(forKey: "login") as! String
    }()
}
