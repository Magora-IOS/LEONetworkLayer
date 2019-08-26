//
//  LeoArraySeeking.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/23/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

open class LeoArraySeeking<T>: LeoArray<T> where T:Codable {
    public var nextCursor: String
    public var prevCursor: String
    public var total: Int?
    
    private enum CodingKeys: String, CodingKey {
        case nextCursor
        case prevCursor
        case total
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nextCursor = try container.decode(String.self, forKey: .nextCursor)
        self.prevCursor = try container.decode(String.self, forKey: .prevCursor)
        self.total = try? container.decode(Int.self, forKey: .total)
        try super.init(from: decoder)
    }
}


