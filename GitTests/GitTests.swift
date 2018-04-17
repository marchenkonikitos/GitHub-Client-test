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
import Moya

class GitHubTests: XCTestCase {
    func testAuth() {
        let userService = DIContainer.containerMock.resolve(UserServicesRealisation.self)
        let userStorage = DIContainer.containerMock.resolve(UserStorageMock.self)
        
        
    }
    
}
