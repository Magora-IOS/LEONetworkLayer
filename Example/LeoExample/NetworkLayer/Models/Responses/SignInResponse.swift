//
//  SignInResponse.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/19/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

struct SignInResponse: Decodable {
    let authInfo: AuthInfoDTO
}
