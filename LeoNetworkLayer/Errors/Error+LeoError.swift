//
//  Error+Leo.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Moya

public extension Error {
    
    var localizedLeoError: ILeoLocalizedError? {
        if let localizedError = self.toLeoError() as? ILeoLocalizedError {
            return localizedError
        }
        return nil
    }

    var leoError: IBaseError? {
        return self.toLeoError()
    }
    
    private func toLeoError() -> IBaseError? {
        return LeoError.leoErrorFrom(self)
    }
    
    var moyaError: MoyaError? {
        if let moyaError = self as? MoyaError {
            return moyaError
        }
        return nil
    }

    var baseLeoError: LeoBaseError? {
        if let providerError = self.toLeoError() as? LeoProviderError {
            if providerError.errorCode.hasState(.leoBaseError) {
                return providerError.underlyingError as? LeoBaseError
            }
        }
        return nil
    }
}

internal extension Error {
    var isAccessTokenSecurityError: Bool {
        if let providerError = self.leoError as? LeoProviderError {
            if providerError.errorCode.hasState(.securityError) {
                return true
            }
        }

        if  let baseError = self.baseLeoError,
            case .securityError = baseError.leoStatusCode,
            case .securityError = baseError.code,
            let apiErrors = baseError.errors {
                for apiError in apiErrors {
                    if apiError.code.isAccessTokenError {
                        return true
                    }
                }
        }
        
        return false
    }
}

