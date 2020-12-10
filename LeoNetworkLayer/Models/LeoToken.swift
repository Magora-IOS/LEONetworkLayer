//
//  LeoToken.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 9/3/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public struct LeoToken: Decodable {
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
}
