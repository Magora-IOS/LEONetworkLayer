//
//  LeoBaseError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

open class LeoBaseError: Codable {
    var errors: [LeoApiCodes]
    var code: LeoCodes
    var message: String
}
