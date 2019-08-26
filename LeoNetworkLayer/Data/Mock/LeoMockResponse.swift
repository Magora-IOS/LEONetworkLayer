//
//  LeoMockResponse.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/23/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

open class LeoMockResponse {
    public class var emptySuccess: Data {
        let mockResponse = """
                    {"data": {},
                     "code":"success"}
                    """
        return mockResponse.data(using: .utf8)!
    }
    
    public class var emptyArray: Data {
        let mockResponse = """
                    {"data": {
                        "page": 0,
                        "pageSize": 50,
                        "total": 54,
                        "items": []
                    },
                     "code":"success"}
                    """
        return mockResponse.data(using: .utf8)!
    }
    
    public class func success(value: String) -> Data {
       return ("""
                    {"data": { \(value) } ,
                     "code":"success"}
                    """).data(using: .utf8)!
    }
    
    public class func success(object: Codable) -> Data {
        if let data = object.toJSONData() {
            let stringData = String(data: data, encoding: .utf8) ?? ""
            return self.success(value: stringData)
        }
        
        return Data()
    }
    
    public class func success(array: [Codable]) -> Data {
        let stringResult = array.compactMap({$0.toJSONData()})
            .compactMap({String(data: $0, encoding: .utf8)})
            .joined(separator: ", ")
        let formated = """
            "items": [ \(stringResult) ]
        """
        let result = self.success(value: formated)
        return result
    }
    
}


