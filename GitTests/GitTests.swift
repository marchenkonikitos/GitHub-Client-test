//
//  GitTests.swift
//  GitTests
//
//  Created by Nikita Marchenko on 4/17/18.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

@testable import GitHub

import Swinject
import KeychainSwift
import XCTest

class GitHubTests: XCTestCase {
    func testAuth() {
        let userService = DIContainer.container.resolve(UserServices.self)!
        
        let keyChain = KeychainSwift()
        let hash = keyChain.get("base64Credentials")
        
        if hash != nil {
            XCTAssertTrue(userService.isAuth)
        } else {
            XCTAssertFalse(userService.isAuth)
        }
    }
}
