//
//  MoyaError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya
import Alamofire

extension MoyaError {

    func leoConverter() -> MoyaError {
        if case MoyaError.underlying(let error, let response) = self {
            
            var currentError = error
            
            if let error = error as? Alamofire.AFError {
                if let underlyingError = error.underlyingError {
                    currentError = underlyingError
                }
            }
            
            if let error = currentError as? URLError {
                let code = URLError.Code(rawValue: error.errorCode)
                switch code {
                case URLError.Code.timedOut:
                    return MoyaError.underlying(LeoProviderError.timeoutError(error), response)

                case URLError.Code.badURL,
                     URLError.Code.unsupportedURL,
                     URLError.Code.notConnectedToInternet,
                     URLError.Code.cannotConnectToHost,
                     URLError.Code.cannotFindHost,
                     URLError.Code.networkConnectionLost,
                     URLError.Code.dnsLookupFailed,
                     URLError.Code.httpTooManyRedirects,
                     URLError.Code.resourceUnavailable,
                     URLError.Code.redirectToNonExistentLocation,
                     URLError.Code.internationalRoamingOff,
                     URLError.Code.callIsActive,
                     URLError.Code.dataNotAllowed,
                     URLError.Code.secureConnectionFailed,
                     URLError.Code.cannotLoadFromNetwork:
                    return MoyaError.underlying(LeoProviderError.connectionFailed(error), response)

                default:
                    return MoyaError.underlying(error, response)
                }
            }

            return MoyaError.underlying(error, response)
        }
        return self
    }
}
