//
//  LeoProvider.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/25/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya
import enum Result.Result
import Alamofire
import RxSwift


open class LeoProviderFactory<T:TargetType> {
    
    public func makeProvider(tokenManager:ILeoTokenManager? = nil, mockType: StubBehavior = .never, callbackQueue: DispatchQueue? = nil, plugins: [PluginType] = [], customConfiguration: URLSessionConfiguration?) -> MoyaProvider<T> {
        
        let allPlugins = makeTokenPlugins(tokenManager: tokenManager) + makeLeoPlugins(tokenManager: tokenManager) + plugins
        
        let sessionManager = makeSessionManager(customConfiguration: customConfiguration)
        
        let provider = LeoProvider<T>(stubClosure:{ _ in return mockType }, callbackQueue: callbackQueue, manager: sessionManager, plugins: allPlugins)
        provider.tokenManager = tokenManager
        return provider
    }
    
    
    public func makeProvider(tokenManager:ILeoTokenManager? = nil, mockType: StubBehavior = .never, plugins: [PluginType] = [], timeoutForRequest:TimeInterval = 20.0, timeoutForResponse: TimeInterval = 40.0) -> MoyaProvider<T> {
        
        let configuration = makeConfiguration(timeoutForRequest: timeoutForRequest, timeoutForResponse: timeoutForResponse)
        
        return makeProvider(tokenManager: tokenManager, mockType: mockType, customConfiguration: configuration)
    }
    
    private func makeTokenPlugins(tokenManager:ILeoTokenManager?) -> [PluginType] {
        var result:[PluginType] = []
        if let tokenManager = tokenManager {
            let accessTokenPlugin = AccessTokenPlugin(tokenClosure: tokenManager.getAccessToken)
            result = [accessTokenPlugin]
        }
        return result
    }
    
    private func makeLeoPlugins(tokenManager:ILeoTokenManager?) -> [PluginType] {
        let leoPlugin = LeoPlugin(tokenManager: tokenManager)
        return [leoPlugin]
    }
    
    private func makeConfiguration(timeoutForRequest:TimeInterval = 20.0, timeoutForResponse: TimeInterval = 40.0) ->  URLSessionConfiguration {
        let configuration: URLSessionConfiguration
        configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = timeoutForRequest
        configuration.timeoutIntervalForResource = timeoutForResponse
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return configuration
    }
    
    private func makeSessionManager(customConfiguration: URLSessionConfiguration?) -> SessionManager {
        var sessionManager: Manager
        
        if let configuration = customConfiguration {
            sessionManager = Manager(configuration: configuration)
            sessionManager.startRequestsImmediately = false
        } else {
            sessionManager = MoyaProvider<T>.defaultAlamofireManager()
        }
        
        return sessionManager
    }
    
    public init () {
    }
}


private class LeoProvider<Target>: MoyaProvider<Target> where Target: Moya.TargetType {
    
    var tokenManager:ILeoTokenManager?
    private var disposeBag = DisposeBag()
    
    override func request(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion) -> Cancellable {
        if let tokenManer = self.tokenManager {
            var attempts = tokenManer.numberRefreshTokenAttempts
            if attempts > 10 {
                attempts = 10
            }
            return self.customRequest(target, callbackQueue: callbackQueue, progress: progress, completion: completion, attempts: attempts)
        } else {
            return super.request(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
        }
    }
    
    private func customRequest(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion, attempts: Int) -> Cancellable {
        
        return super.request(target, callbackQueue: callbackQueue, progress: progress, completion:
            { (result) in
                
                let finalCompletion: Completion = completion
                
                switch result {
                case .success:
                    completion(result)
                case .failure(let error):
                    if let authorizable = target as? AccessTokenAuthorizable,
                       let tokenManager = self.tokenManager {
                            var attemptsLeft = attempts
                            let requestAuthorizationType = authorizable.authorizationType
                        
                            if case .none = requestAuthorizationType {
                                completion(result)
                            } else {
                                if let error = error.baseLeoError {
                                    if case .securityError = error.code {
                                        tokenManager.refreshToken()?.subscribe {
                                            [weak self] _ in
                                            let failedResult: Result<Response, MoyaError> = .failure(MoyaError.underlying(LeoProviderError.refreshTokenFailed, nil))
                                            
                                            if let `self` = self {
                                                attemptsLeft -= 1
                                            
                                                if attemptsLeft <= 0 {
                                                    finalCompletion(failedResult)
                                                    self.tokenManager?.clearTokensAndHandleLogout()
                                                } else {
                                                    _ = self.customRequest(target, callbackQueue: callbackQueue, progress: progress, completion: { (result) in
                                                        finalCompletion(result)
                                                    }, attempts: attemptsLeft)
                                                }
                                            } else {
                                                finalCompletion(failedResult)
                                            }
                                        }.disposed(by: self.disposeBag)
                                    } else {
                                        completion(result)
                                    }
                                } else {
                                    completion(result)
                                }
                            }
                    } else {
                        completion(result)
                    }
                }
        })
    }
    
  

}

