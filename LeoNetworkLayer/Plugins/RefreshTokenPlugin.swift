//
//  RefreshTokenPlugin.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/31/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Moya
import enum Result.Result
import RxSwift

public class RefreshTokenPlugin: PluginType {
    
    private let tokenManager: ILeoTokenManager
    private var request: (RequestType, TargetType)?
    private var result: Result<Moya.Response, MoyaError>?
    private var authorizationType: Moya.AuthorizationType  = .none
    
    public init(tokenManager: ILeoTokenManager) {
        self.tokenManager = tokenManager
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        guard let authorizable = target as? AccessTokenAuthorizable else { return request }
        
        let requestAuthorizationType = authorizable.authorizationType
        self.authorizationType = requestAuthorizationType
        
        let request = request
        return request
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        self.request = (request, target)
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        self.result = result
    }            
    
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        
        print("processToken")
        
        let result = result
        
        switch result {
        case .failure(let error):
            return .failure(error)
        case .success(let response):
            
            if case .none = self.authorizationType {
                return .success(response)
            }
            
            if response.isNotAuthorized {
                self.tokenManager.clearTokensAndHandleLogout()
                return .failure(MoyaError.underlying(LeoProviderError.securityError, response))
                                
                print("RefreshNotAuthorizedTOKEN=")
                
                print("NotAuthorized2")
                
                func monitorResource() -> Observable<String?> {
                    return Observable.of("a", "Hell")
                }
                
                let expectedValue = "Hello"
                let monitoringFound = monitorResource().filter { $0 == expectedValue }
                
                //let timoutSeconds = 20
                //let timeout = Observable<String?>.error(RxError.timeout)
                
                let monitoringWithTimeout = Observable<Any>.never()
                    .timeout(self.tokenManager.refreshTokenTimeout, scheduler: MainScheduler.instance)
                    .takeUntil(monitoringFound)
                
                _ = monitoringWithTimeout.debug("sequence").subscribe{}
                
                /*
                 self.tokenManager?.refreshToken()?.subscribe { event in
                 switch result {
                 case .success(let response):
                 print("refreshOK")
                 case .failure(let error):
                 print("refreshNot")
                 }
                 }.disposed(by: self.disposeBag)
                 //tokenManager?.clearTokensAndHandleLogout()
                 //tokenManager
                 */
                /*
                 authenticationProvider.request(.refreshToken(params)) { result in
                 switch result {
                 case .success(let response):
                 let token = response.mapJSON()["token"]
                 let newRefreshToken = response.mapJSON()["refreshToken"]
                 //overwrite your old token with the new token
                 //overwrite your old refreshToken with the new refresh token
                 
                 closure(.success(request)) // This line will "resume" the actual request, and then you can use AccessTokenPlugin to set the Authentication header
                 case .failure(let error):
                 closure(.failure(error)) //something went terrible wrong! Request will not be performed
                 }
                 }*/
                
                print("AuthEnd")
                //response.map(<#T##type: Decodable.Protocol##Decodable.Protocol#>)
                //TODO: refresh token
                //self.tokenManager?.getRefreshToken()
                
                
                
                print("RefreshTokenEnd")
            }
            return .success(response)
        }
    }
}
