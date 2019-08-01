//
//  Errors.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Moya
import enum Result.Result

public class LeoPlugin: PluginType {
    private var tokenManager: ILeoTokenManager?
    private var request: (RequestType, TargetType)?
    private var result: Result<Moya.Response, MoyaError>?
    
    private var didPrepare = false
    
    public init(tokenManager: ILeoTokenManager?) {
        self.tokenManager = tokenManager
    }
    
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue("yes", forHTTPHeaderField: "prepared")
        return request
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        print("send")
        self.request = (request, target)
        didPrepare = request.request?.allHTTPHeaderFields?["prepared"] == "yes"
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        print("did receive")
        self.result = result
    }
    
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        print("process")
        
        let result = result
        
        switch result {
        case .failure(let error):
            return .failure(error)
        case .success(let response):
            
            if let serverError = response.checkServerError() {
                return serverError
            }
            
            if response.isNotAuthorized {
                self.tokenManager?.clearTokensAndHandleLogout()
                return .failure(MoyaError.underlying(LeoProviderError.securityError, response))
            }
            
            if let code = response.parseCode() {
                
            }
            
            
            if let data = response.parseSuccess() {
                return data
            }
            
            
            
            return .failure(MoyaError.statusCode(response))
        }
    }
    

    
    //func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        
    
        /*let json = JSON(data: response.data)
        
        // Convert response.data to APIError instance
        guard let apiError = APIError(jsonData: json) else {
            return Result.success(response.data)
        }
        
        let userInfo = [NSLocalizedDescriptionKey: apiError.message, "httpStatus": response.statusCode, "areaStatus": apiError.errorCode, "url": response.request?.url?.absoluteString] as [String : Any]
        let mappedError: NSError = NSError(domain: "custom error domain", code: response.statusCode, userInfo: userInfo)
        */
        //return Result.failure(mappedError)
}
