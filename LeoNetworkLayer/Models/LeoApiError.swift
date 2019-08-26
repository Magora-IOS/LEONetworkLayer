//
//  LeoApiError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation


open class LeoApiError: Codable {
    public var code: String
    public var message: String?
    public var field: String?
}
