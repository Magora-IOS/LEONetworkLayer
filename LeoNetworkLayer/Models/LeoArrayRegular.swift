//
//  LeoArrayRegular.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/23/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

open class LeoArrayRegular<T>: LeoArray<T> where T: Decodable {
    public var page: Int = 0
    public var pageSize: Int = 0
    public var total: Int?

    private enum CodingKeys: String, CodingKey {
        case page
        case pageSize
        case total
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.pageSize = try container.decode(Int.self, forKey: .pageSize)
        self.total = try? container.decode(Int.self, forKey: .total)
        try super.init(from: decoder)
    }
}

