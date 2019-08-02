//
//  LeoApiError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation


open class LeoApiError: Codable {
    var code: String
    var message: String?
    var field: String?
}
