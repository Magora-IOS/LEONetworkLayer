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
            return URL(string: Constants.devPath)!
        #elseif UAT
            return URL(string: Constants.uatPath)!
        #elseif STAGE
            return URL(string: Constants.stagePath)!
        #else
            return URL(string: Constants.prodPath)!
        #endif
    }
}

