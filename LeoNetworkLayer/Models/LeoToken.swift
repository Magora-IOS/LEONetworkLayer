//
//  LeoToken.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 9/3/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public struct LeoToken: Codable {
    public let accessToken: String
    public let refreshToken: String
    public let accessTokenExpire: Date?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case accessTokenExpire
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
        
        if let dateString: String = try? container.decode(String.self, forKey: .accessTokenExpire) {
            self.accessTokenExpire = dateString.iso8601(withFormat: .dateTimeUtc0ms)
        } else {
            self.accessTokenExpire = nil
        }
    }
     
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.accessToken, forKey: .accessToken)
        try container.encode(self.refreshToken, forKey: .refreshToken)
        try? container.encode(self.accessTokenExpire?.iso8601(withFormat: .dateTimeUtc0ms) ?? "", forKey: .accessTokenExpire)
    }
}
