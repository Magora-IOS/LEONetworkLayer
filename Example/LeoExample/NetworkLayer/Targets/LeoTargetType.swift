//
//  LeoTargetType.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/25/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya

protocol LeoTargetType: TargetType, AccessTokenAuthorizable  {}

extension LeoTargetType {
    var baseURL: URL {
        #if DEBUG
            return URL(string: "https://jsonplaceholder.typicode.com")!
        #elseif UAT
            return URL(string: "http://uat.midea.back.magora.team/api/v0.1")!
        #elseif STAGE
            return URL(string: "https://stage.back.midea-education.com/api/v0.1")!
        #else
            return URL(string: "https://jsonplaceholder.typicode.com")!
        #endif
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var authorizationType: AuthorizationType {
        return .bearer
    }
}

