//
//  SigninRequest.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/29/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import UIKit

class MetaParameters: Codable {
    var platform: String
    var deviceID: String?
    var versionApp: String?

    init() {
        self.versionApp = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.platform = "i_o_s"
        //or
        //let systemVersion = UIDevice.current.systemVersion
        //self.platform = "ios.\(systemVersion)"
    }
}

class TokenRequestParameters: Codable {
    var code: String?
    var phone: String?
    var meta: MetaParameters

    init() {
        self.meta = MetaParameters()
    }
}




