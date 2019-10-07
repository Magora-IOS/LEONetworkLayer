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

    var leoError: ILeoError? {
        return self.toLeoError()
    }
    
    private func toLeoError() -> ILeoError? {
        return LeoError.leoErrorFrom(self)
    }
    
    var moyaError: MoyaError? {
        if let moyaError = self as? MoyaError {
            return moyaError
        }
        return nil
    }

    var baseLeoError: LeoBaseError? {
        if let baseError = self.toLeoError() as? LeoProviderError {
            if case .leoBaseError(let leoBaseError) = baseError {
                return leoBaseError
            }
        }
        return nil
    }
}

internal extension Error {
    var isAccessTokenSecurityError: Bool {
        if let providerError = self.leoError as? LeoProviderError {
            if case .securityError = providerError {
                return true
            }
        }

        if  let error = self.baseLeoError,
            case .securityError = error.code,
            let baseLeoError = error.baseLeoError,
            let apiErrors = baseLeoError.errors {
                for apiError in apiErrors {
                    if apiError.code.isAccessTokenError {
                        return true
                    }
                }
        }
        
        return false
    }
}

