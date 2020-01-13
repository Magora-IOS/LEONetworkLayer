//
//  LeoProvider.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/25/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import RxSwift

open class LeoProviderFactory<T: TargetType> {

    public func makeProvider(tokenManager: ILeoTokenManager? = nil, mockType: StubBehavior = .never, consoleLogging: Bool = false, callbackQueue: DispatchQueue? = nil, plugins: [PluginType] = [], customConfiguration: URLSessionConfiguration?) -> MoyaProvider<T> {

        var allPlugins = makeTokenPlugins(tokenManager: tokenManager) + makeLeoPlugins(tokenManager: tokenManager)
        if consoleLogging {
            allPlugins += [NetworkLoggerPlugin()]
        }
        allPlugins += plugins
        
        let session = makeSession(customConfiguration: customConfiguration)
        
        let provider = LeoProvider<T>(stubClosure: { _ in return mockType }, callbackQueue: callbackQueue, session: session, plugins: allPlugins)
        provider.tokenManager = tokenManager
        return provider
    }


    public func makeProvider(tokenManager: ILeoTokenManager? = nil, mockType: StubBehavior = .never, consoleLogging: Bool = false, callbackQueue: DispatchQueue? = nil, plugins: [PluginType] = [], timeoutForRequest: TimeInterval = 20.0, timeoutForResponse: TimeInterval = 40.0) -> MoyaProvider<T> {

        let configuration = makeConfiguration(timeoutForRequest: timeoutForRequest, timeoutForResponse: timeoutForResponse)

        return makeProvider(tokenManager: tokenManager, mockType: mockType, consoleLogging: consoleLogging, callbackQueue: callbackQueue, customConfiguration: configuration)
    }

    private func makeTokenPlugins(tokenManager: ILeoTokenManager?) -> [PluginType] {
        var result: [PluginType] = []
        if let tokenManager = tokenManager {
            let accessTokenPlugin = AccessTokenPlugin(tokenClosure: tokenManager.getAccessToken)
            result = [accessTokenPlugin]
        }
        return result
    }

    private func makeLeoPlugins(tokenManager: ILeoTokenManager?) -> [PluginType] {
        let leoPlugin = LeoPlugin(tokenManager: tokenManager)
        return [leoPlugin]
    }

    private func makeConfiguration(timeoutForRequest: TimeInterval = 20.0, timeoutForResponse: TimeInterval = 40.0) -> URLSessionConfiguration {
        let configuration: URLSessionConfiguration
        configuration = URLSessionConfiguration.default
        configuration.headers = HTTPHeaders.default
        configuration.timeoutIntervalForRequest = timeoutForRequest
        configuration.timeoutIntervalForResource = timeoutForResponse
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return configuration
    }

    private func makeSession(customConfiguration: URLSessionConfiguration?) -> Session {
        var session: Session
        if let configuration = customConfiguration {
            session = Session(configuration: configuration)
        } else {
            session = MoyaProvider<T>.defaultAlamofireSession()
        }
        return session
    }

    public init() {
    }
}

open class LeoProvider<Target>: MoyaProvider<Target> where Target: Moya.TargetType {

    var tokenManager: ILeoTokenManager?
    
    override open func request(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion) -> Cancellable {
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

    private func checkAuthorization(target: Target) -> Bool {
        var result = false
        if let authorizable = target as? AccessTokenAuthorizable,
           let _ = self.tokenManager {

            let requestAuthorizationType = authorizable.authorizationType
            if case .none = requestAuthorizationType {
            } else {
                result = true
            }
        }
        return result
    }

    private func customRequest(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion, attempts: Int) -> Cancellable {

        return super.request(target, callbackQueue: callbackQueue, progress: progress, completion:
        { [weak self] (result) in

            let finalCompletion: Completion = completion

            switch result {
            case .success:
                completion(result)
            case .failure(let error):
                
                guard
                    let `self` = self,
                    let tokenManager = self.tokenManager,
                    self.checkAuthorization(target: target),
                    error.isAccessTokenSecurityError else {
                        completion(result)
                    return
                }
                
                let failedResult: Result<Response, MoyaError> = .failure(MoyaError.underlying(LeoProviderError.refreshTokenFailed, nil))
                
                var attemptsLeft = attempts
                let getNewTokens = tokenManager.getNewTokens()
                
                if (attemptsLeft <= 0) || (getNewTokens == nil) {
                    finalCompletion(failedResult)
                    self.tokenManager?.clearTokensAndHandleLogout()
                } else {
                    TokenRefresher.start(getNewTokens: getNewTokens!) {
                        [weak self] completable in
                        
                        if let `self` = self {
                            switch completable {
                            case .completed:
                                attemptsLeft -= 1
                                _ = self.customRequest(target, callbackQueue: callbackQueue, progress: progress, completion: { (result) in
                                    finalCompletion(result)
                                }, attempts: attemptsLeft)
                            case .error( _):
                                finalCompletion(failedResult)
                                self.tokenManager?.clearTokensAndHandleLogout()
                            }
                        } else {
                            finalCompletion(failedResult)
                        }
                    }
                }
            }
        })
    }
}

