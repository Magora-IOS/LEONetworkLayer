//
//  LeoArray.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/23/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

open class LeoArray<T>: Decodable where T: Decodable {
    public var items: [T] = []

    private enum CodingKeys: String, CodingKey {
        case items
    }
}
