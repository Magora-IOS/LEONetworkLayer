//
//  LeoStatusCode.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 9/4/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public enum LeoStatusCode: Int {
    case success = 200
    case businessConflict = 409
    case unprocessableEntity = 422
    case badParameters = 400
    case internalError = 500
    case notFound = 404
    case securityError = 401
    case permissionError = 403
    case unknown = 0
    
    static func valueFrom(_ statusCode: Int) -> LeoStatusCode {
        if (statusCode >= 500) && (statusCode <= 599) {
            return .internalError
        }
        
        if (statusCode >= 200) && (statusCode <= 299) {
            return .success
        }
        
        return LeoStatusCode(rawValue: statusCode) ?? .unknown
    }
    
    public func toLeoCode() -> LeoCode {
        switch self  {
        case .success :
            return LeoCode.success
        case .businessConflict:
            return LeoCode.businessConflict
        case .unprocessableEntity:
            return LeoCode.unprocessableEntity
        case .badParameters:
            return LeoCode.badParameters
        case .internalError:
            return LeoCode.internalError
        case .notFound:
            return LeoCode.notFound
        case .securityError:
            return LeoCode.securityError
        case .permissionError:
            return LeoCode.permissionError
        case .unknown :
            return LeoCode.unknown
        }
    }
}
