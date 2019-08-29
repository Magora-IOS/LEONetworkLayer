//
//  LeoBaseError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya

open class LeoBaseError: ILeoError, Codable {
    public let code: LeoCodes
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

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.code = try container.decode(LeoCodes.self, forKey: .code)
        self.rawCode = try container.decode(String.self, forKey: .code)
        self.message = try? container.decode(String.self, forKey: .message)
        self.errors = try? container.decode([LeoApiError].self, forKey: .errors)
    }

    public func configureWithResponse(_ moyaResponse: Moya.Response) {
        self.statusCode = moyaResponse.statusCode
        self.request = moyaResponse.request
        self.response = moyaResponse.response
    }
}
