
//
//  DIContainerMock.swift
//  GitTests
//
//  Created by Nikita Marchenko on 4/17/18.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

@testable import GitHub
import Foundation
import Swinject
import Moya

class ContainerMock {
    static let containerMock: Container = {
        let _container = Container()
        
        _container.register(MoyaProvider<UserTarget>.self) { _ in
            MoyaProvider<UserTarget>(stubClosure: {_ in
                return .immediate
            })
        }
        
        _container.register(UserStorageMock.self) { _ in
            UserStorageMock()
        }
        
        _container.register(UserServices.self) { r in
            UserServicesRealisation(provider: r.resolve(MoyaProvider<UserTarget>.self)!,
                                    storage: r.resolve(UserStorageMock.self)!)
        }
        
        return _container
    }()
    
    private init() {}
}
