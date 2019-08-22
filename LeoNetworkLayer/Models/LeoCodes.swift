//
//  LeoCodes.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 7/30/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public enum LeoCodes: String, Codable  {
    case success = "success"
    case businessConflict = "business_conflict"
    case unprocessableEntity = "unprocessable_entity"
    case badParameters = "bad_parameters"
    case internalError = "internal_error"
    case notFound = "not_found"
    case securityError = "security_error"
    case permissionError = "permission_error"
    case unknown = "unknown"
    
    public init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(String.self) {
            self = LeoCodes(rawValue: value) ?? .unknown
        } else {
            self = .unknown
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}



