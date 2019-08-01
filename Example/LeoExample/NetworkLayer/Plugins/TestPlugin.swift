//
//  Errors.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Moya
import enum Result.Result

final class TestPlugin: PluginType {
    var request: (RequestType, TargetType)?
    var result: Result<Moya.Response, MoyaError>?
    var didPrepare = false
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print("==========")
        print("prepare2")
        
        var request = request
        request.addValue("yes", forHTTPHeaderField: "prepared")
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        print("send2")
        self.request = (request, target)
        
        // We check for whether or not we did prepare here to make sure prepare gets called
        // before willSend
        didPrepare = request.request?.allHTTPHeaderFields?["prepared"] == "yes"
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        print("did receive2")
        self.result = result
        
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        print("process2")
        let result = result
        
        switch result {
        case .failure(let error):
            print("error2")
            return .failure(error)
            
            /*if let request = error.response?.request, let cache = URLCache.cachedResponse(request) {
             let cachedResponse = Response(request: request, cache: cache)
             return Result(cachedResponse, failWith: error)
             }*/
        case .success(let response):
                        
            
            print("response")
            return .success(response)
        }
        
        /*
         if case .success(let response) = result {
         let processedResponse = Response(statusCode: -1, data: response.data, request: response.request, response: response.response)
         result = .success(processedResponse)
         }*/
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
