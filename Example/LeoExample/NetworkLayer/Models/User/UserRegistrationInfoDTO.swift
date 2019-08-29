//
//  UserRegistrationInfoDTO.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/22/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

struct UserRegistrationInfoDTO: Codable {
    var name: String = ""
    var email: String = ""
    var zip: String = ""
}
