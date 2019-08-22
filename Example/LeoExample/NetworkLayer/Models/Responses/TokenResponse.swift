//
//  TokenResponse.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/21/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
