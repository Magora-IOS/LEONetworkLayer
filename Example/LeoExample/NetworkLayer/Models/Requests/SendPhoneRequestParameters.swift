//
//  SendPhoneRequestParameters.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 9/3/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

struct SendPhoneRequestParameters: Encodable {
    let phone: String
    
    init(phone: String) {
        self.phone = phone
    }
}
