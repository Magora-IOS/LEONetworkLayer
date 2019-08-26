//
//  LeoProviderError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/1/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya

public enum LeoProviderError: ILeoError {
    case serverError
    case securityError
    case badLeoResponse
    case leoBaseError(LeoBaseError)
    case timeoutError(URLError)
    case connectionFailed(URLError)
    case refreshTokenFailed
    case moyaError(MoyaError)    
}


