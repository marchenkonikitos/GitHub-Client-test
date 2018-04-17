//
//  MoyaProvider+PromiseKit.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 30.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import PromiseKit
import Moya

extension MoyaProvider {
    func request(_ target: Target) -> Promise<Response> {
        return Promise<Moya.Response> { seal in
            self.request(target, callbackQueue: .main, progress: nil, completion: { result in
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        seal.fulfill(response)
                    } catch {
                        seal.reject(error)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            })
        }
    }
}

extension TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
