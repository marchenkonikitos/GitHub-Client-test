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
    
    let userStorage = ContainerMock.containerMock.resolve(UserStorageMock.self)!
    let userService = ContainerMock.containerMock.resolve(UserServices.self)!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        userStorage?.saveUser(hash: "")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuth() {
        XCTAssertTrue(self.userService.isAuth == false, "Precondition fail")
        userService.login(username: "1", password: "1").done {_ in
            XCTAssertTrue(self.userService.isAuth == true, "NOT LOGGED IN")
        }.catch{ error in
            XCTFail(error.localizedDescription)
        }
    }
    
}
