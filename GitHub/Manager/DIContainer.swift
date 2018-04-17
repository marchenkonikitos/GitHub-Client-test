//
//  Container.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 4/5/18.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import Swinject
import Moya

class DIContainer {
    
    static let container: Container = {
        let _container = Container()
        
        _container.register(MoyaProvider<UserTarget>.self) { _ in
            MoyaProvider<UserTarget>()
        }
        
        _container.register(MoyaProvider<RepositoriesTarget>.self) { _ in
            MoyaProvider<RepositoriesTarget>()
        }
        
        _container.register(MoyaProvider<IssuesTarget>.self) { _ in
            MoyaProvider<IssuesTarget>(plugins: [AccessTokenPlugin(tokenClosure: UserStorage().getUserLogin())])
        }
        
        _container.register(MoyaProvider<CommentTarget>.self) { _ in
            MoyaProvider<CommentTarget>()
        }
        
        _container.register(Variables.self) { _ in
            Variables()
        }
    
        _container.register(UserStorage.self) { _ in
            UserStorage()
        }
        
        _container.register(RepositoriesStorage.self) { _ in
            RepositoriesStorage()
        }
        
        _container.register(IssuesStorage.self) { _ in
            IssuesStorage()
        }
        
        _container.register(CommentsStorage.self) { _ in
            CommentsStorage()
        }
        
        _container.register(UserServices.self) { r in
            UserServicesRealisation(provider: r.resolve(MoyaProvider<UserTarget>.self)!,
                                storage: r.resolve(UserStorage.self)!)
        }
        _container.register(RepositoryServices.self) { r in
            RepositoryServices(provider: r.resolve(MoyaProvider<RepositoriesTarget>.self)!,
                               variable: r.resolve(Variables.self)!,
                               storage: r.resolve(RepositoriesStorage.self)!)
        }
        
        _container.register(IssuesService.self) { r in
            IssuesService(variable: r.resolve(Variables.self)!,
                          storage: r.resolve(IssuesStorage.self)!,
                          provider: r.resolve(MoyaProvider<IssuesTarget>.self)!)
        }
        
        _container.register(CommentsServices.self) { r in
            CommentsServices(variable: r.resolve(Variables.self)!,
                             storage: r.resolve(CommentsStorage.self)!,
                             provider: r.resolve(MoyaProvider<CommentTarget>.self)!)
        }
        
        return _container
    }()

}
