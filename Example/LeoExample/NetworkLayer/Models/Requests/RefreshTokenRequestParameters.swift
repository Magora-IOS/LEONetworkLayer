//
//  RefreshTokenRequestParameters.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 9/3/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

struct RefreshTokenRequestParameters: Encodable {
    let refreshToken: String
    
    init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}



