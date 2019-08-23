//
//  Errors.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Moya
import enum Result.Result

open class LeoPlugin: PluginType {
    private var tokenManager: ILeoTokenManager?
    private var request: (RequestType, TargetType)?
    private var result: Result<Moya.Response, MoyaError>?
    
    init(tokenManager: ILeoTokenManager?) {
        self.tokenManager = tokenManager
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
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
        let result = result
        
        switch result {
        case .failure(let error):
            return .failure(error.leoConverter())
        case .success(let response):
            
            if let serverError = response.checkServerError() {
                return serverError
            }
            
            if let errors = response.parseErrors() {
                return errors
            }
            
            if let data = response.parseSuccess() {
                return data
            }
            
            return .failure(MoyaError.statusCode(response))
        }
    }
}
