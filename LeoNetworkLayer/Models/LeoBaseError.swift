//
//  LeoBaseError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya

public struct LeoBaseError: ILeoError, Decodable {
    public let code: LeoCode
    public let rawCode: String
    public let message: String?
    public let errors: [LeoApiError]?
    public var statusCode: Int?
    public var request: URLRequest?
    public var response: URLResponse?

    private enum CodingKeys: String, CodingKey {
        case code
        case errors
        case message
    }
    
    init(code: LeoCode, rawCode: String) {
        self.code = code
        self.rawCode = rawCode
        self.message = code.rawValue
        self.errors = nil
        self.statusCode = nil
        self.request = nil
        self.response = nil
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.code = try container.decode(LeoCode.self, forKey: .code)
        self.rawCode = try container.decode(String.self, forKey: .code)
        self.message = try? container.decode(String.self, forKey: .message)
        self.errors = try? container.decode([LeoApiError].self, forKey: .errors)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawCode, forKey: .code)
        try? container.encode(self.errors, forKey: .errors)
        try? container.encode(self.message, forKey: .message)        
    }
    
    mutating public func configureWithResponse(_ moyaResponse: Moya.Response) {
        self.statusCode = moyaResponse.statusCode
        self.request = moyaResponse.request
        self.response = moyaResponse.response
    }
    
    public static func from(_ leoStatusCode: LeoStatusCode) -> LeoBaseError? {
        let code: LeoCode = leoStatusCode.toLeoCode()
        
        if case .success = code {
            return nil
        }
        
        if case .unknown = code {
            return nil
        }
        
        return LeoBaseError(code: code, rawCode: code.rawValue)
    }
}
