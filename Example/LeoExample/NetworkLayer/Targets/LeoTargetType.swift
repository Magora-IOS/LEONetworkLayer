//
//  LeoTargetType.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/25/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import LEONetworkLayer
import Moya
import Alamofire

extension ILeoTargetType {
    var baseURL: URL {
        #if DEBUG
            return URL(string: "http://dev.midea.back.magora.team/api/v0.1")!
        #elseif UAT
            return URL(string: "http://uat.midea.back.magora.team/api/v0.1")!
        #elseif STAGE
            return URL(string: "https://stage.back.midea-education.com/api/v0.1")!
        #else
            return URL(string: "http://dev.midea.back.magora.team/api/v0.1")!
        #endif
    }
}

