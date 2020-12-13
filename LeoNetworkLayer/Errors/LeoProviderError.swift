//
//  LeoProviderError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/1/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya

public enum LeoProviderErrorCode: Int, IBaseErrorCode {
    case serverError = 0
    case securityError = 1
    case badLeoResponse = 2
    case leoBaseError = 3
    case timeoutError = 4
    case connectionFailed = 5
    case refreshTokenFailed = 6
    case moyaError = 7
}

public class LeoProviderError: BaseError <LeoProviderErrorCode> {
    public override var domainShortname: String {
        "PRVE"
    }
}

