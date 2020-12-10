//
//  LeoApiError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public struct LeoApiError: Decodable {
    public let code: LeoApiCodes
    public let rawCode: String
    public let message: String?
    public let field: String?

    private enum CodingKeys: String, CodingKey {
        case code
        case message
        case field
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.code = try container.decode(LeoApiCodes.self, forKey: .code)
        self.rawCode = try container.decode(String.self, forKey: .code)
        self.message = try? container.decode(String.self, forKey: .message)
        self.field = try? container.decode(String.self, forKey: .field)
    }
}
