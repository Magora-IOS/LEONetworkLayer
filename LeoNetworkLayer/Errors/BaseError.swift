//
//  BaseError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 12/10/20.
//  Copyright © 2020 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public protocol IBaseErrorCode: RawRepresentable where RawValue == Int {}

public protocol IBaseError where Self: NSError  {
    var domainShortname: String {get}
    var underlyingError: Any? {get}
    var systemMessage: String? {get}
}

open class BaseError<ErrorCode: IBaseErrorCode>: NSError, IBaseError {
    public init(code: ErrorCode, underlyingError: Error? = nil, systemMessage: String? = nil) {
        var userInfo: [String: Any] = [:]
        if let underlyingError = underlyingError {
            userInfo[NSUnderlyingErrorKey] = underlyingError
        }
        if let systemMessage = systemMessage {
            userInfo[NSLocalizedFailureReasonErrorKey] = systemMessage
        }
        super.init(domain: String(describing: type(of: self)), code: code.rawValue, userInfo: userInfo)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public var errorCode: ErrorCode {
        ErrorCode(rawValue: self.code)!
    }
    
    open var domainShortname: String {
        String(describing: type(of: self))
    }
    
    public var underlyingError: Any? {
        self.userInfo[NSUnderlyingErrorKey]
    }
    
    public var systemMessage: String? {
        userInfo[NSLocalizedFailureReasonErrorKey] as? String
    }
}
