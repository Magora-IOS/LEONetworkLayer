//
//  LeoError.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya

public protocol LeoErrorConverter {
    static func leoErrorFrom(_ error: Error) -> IBaseError?
    static func leoErrorFrom(_ error: NSError) -> IBaseError?
    static func leoErrorFrom(_ result: Result<Response, MoyaError>) -> IBaseError?
}


public struct LeoError: LeoErrorConverter {
    public static func leoErrorFrom(_ result: Result<Response, MoyaError>) -> IBaseError? {
        let result = result
        switch result {
        case .failure(let error):
            return self.leoErrorFrom(error)
        case .success(_):
            return nil
        }
    }
    
    public static func leoErrorFrom(_ error: Error) -> IBaseError? {
        if let moyaError = error as? MoyaError {
            if case .underlying(let underlyingError, _) = moyaError {
                if let leoError = underlyingError as? IBaseError {
                    return leoError
                }
            }
            return LeoProviderError(code: .moyaError, underlyingError: moyaError)
        }

        if let leoError = error as? IBaseError {
            return leoError
        }

        return nil
    }
    
    public static func leoErrorFrom(_ error: NSError) -> IBaseError? {
        if let leoError = error as? IBaseError {
            return leoError
        }
        return nil
    }
}

