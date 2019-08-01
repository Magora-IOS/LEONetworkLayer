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

open class LeoProvider<T:TargetType>: MoyaProvider<T> {
    public init(tokenManager:ILeoTokenManager?, mockType: LeoMock = .none, plugins: [PluginType] = [] ) {
        var mockClosure: StubClosure
        switch mockType {
            case LeoMock.none:
                mockClosure = MoyaProvider<T>.neverStub
            case LeoMock.immediately:
                mockClosure = MoyaProvider<T>.immediatelyStub
            case LeoMock.delay(let seconds):
                mockClosure = MoyaProvider<T>.delayedStub(seconds)
        }
        
        let leoPlugin = LeoPlugin(tokenManager: tokenManager)
        var allPlugins:[PluginType] = [leoPlugin] + plugins
        
        if let tokenManager = tokenManager {
            let accessTokenPlugin = AccessTokenPlugin(tokenClosure: tokenManager.getAccessToken)
            let refreshTokenPlugin = RefreshTokenPlugin(tokenManager: tokenManager)
            allPlugins.insert(refreshTokenPlugin, at: 0)
            allPlugins.insert(accessTokenPlugin, at: 0)
            
            let requestClosure: RequestClosure = LeoProvider.endpointToken(manager: tokenManager)
        let endpointClosure = { (target: T) -> Endpoint in
                
                //MoyaProvider.defaultEndpointMapping(for: target)
                let defaultEndpoint = Endpoint(url: "http://testo.com", sampleResponseClosure: { .networkResponse(200, Data()) }, method: Alamofire.HTTPMethod.get , task: Task.requestPlain, httpHeaderFields: nil)
                print("endpoint2")
                return defaultEndpoint
            }
            /*
            super.init(endpointClosure: <#T##(TargetType) -> Endpoint#>, requestClosure: <#T##(Endpoint, @escaping (Result<URLRequest, MoyaError>) -> Void) -> Void#>, stubClosure: <#T##(TargetType) -> StubBehavior#>, callbackQueue: <#T##DispatchQueue?#>, manager: <#T##Manager#>, plugins: <#T##[PluginType]#>, trackInflights: <#T##Bool#>)
            */
            
            super.init(requestClosure: requestClosure, stubClosure: mockClosure, plugins: allPlugins)
        } else {
            super.init(stubClosure: mockClosure, plugins: allPlugins)
        }
    }
    
    
    
    
    
    static func endpointToken(manager: ILeoTokenManager) -> MoyaProvider<Target>.RequestClosure {
        return { (endpoint, closure) in
            let request = try! endpoint.urlRequest()
            print("oki")
            
            closure(.success(request))
            
            
            
            /*
            //Getting the original request
            let request = try! endpoint.urlRequest()
            
            //assume you have saved the existing token somewhere
            if (#tokenIsNotExpired#) {
                // Token is valid, so just resume the original request
                closure(.success(request))
                return
            }
            
            //Do a request to refresh the authtoken based on refreshToken
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
        }
    }
}
