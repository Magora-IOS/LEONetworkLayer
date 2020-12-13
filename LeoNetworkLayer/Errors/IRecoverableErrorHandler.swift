//
//  IRecoverableErrorHandler.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 12/10/20.
//  Copyright © 2020 Yuriy Savitskiy. All rights reserved.
//

import Foundation

protocol IRecoverableErrorHandler {
    associatedtype ErrorCode: IBaseErrorCode
    func recover(_ error: BaseError<ErrorCode>,
                 currentlyRetryAttempt: Int,
                 success: @escaping (ErrorRecoveryResult) -> Void,
                 failure: @escaping (BaseError<ErrorCode>) -> Void)
}

enum ErrorRecoveryResult {
    case cannotHandle
    case didHandle
}
