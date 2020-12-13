//
//  LeoBaseError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya

public struct LeoBaseError: Error, Decodable {
    public let code: LeoCode
    public let rawCode: String
    public let message: String?
    public let errors: [LeoApiError]?
    public var leoStatusCode: LeoStatusCode?
    public var statusCode: Int?
    public var request: URLRequest?
    public var response: URLResponse?
    public var data: Data?

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
    
    mutating public func configureWithResponse(_ moyaResponse: Moya.Response) {
        self.statusCode = moyaResponse.statusCode
        self.leoStatusCode = moyaResponse.leoStatusCode
        self.request = moyaResponse.request
        self.response = moyaResponse.response
        self.data = moyaResponse.data
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
