//
//  Errors.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

//
//  You can use your own moya plugins in LeoProvider. Simple example.
//
//  lazy public var accountProvider = LeoProviderFactory<AuthentificationTarget>().makeProvider(tokenManager: tokenManager, plugins: [TestPlugin])
//
//

import Moya

final class TestPlugin: PluginType {
    var request: (RequestType, TargetType)?
    var result: Result<Moya.Response, MoyaError>?
    var didPrepare = false

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue("yes", forHTTPHeaderField: "prepared")
        return request
    }

    func willSend(_ request: RequestType, target: TargetType) {
        self.request = (request, target)
        didPrepare = request.request?.allHTTPHeaderFields?["prepared"] == "yes"
    }

    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        self.result = result
    }

    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        let result = result
        switch result {
        case .failure(let error):
            print("Test plugin error")
            return .failure(error)
        case .success(let response):
            print("Test plugin success")
            return .success(response)
        }
    }
}
