//
//  LeoApiCodes.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public enum LeoApiCodes: String, Codable {

    case invalidAuthData = "sec.invalid_auth_data"
    case loginShouldBeConfirmed = "sec.login_should_be_confirmed"
    case refreshTokenInvalid = "sec.refresh_token_invalid"
    case accessTokenInvalid = "sec.access_token_invalid"
    case accessTokenExpired = "sec.access_token_expired"
    case passCodeNotValid = "sec.pass_code_not_valid"

    case fieldNotBlank = "common.field_not_blank"
    case fieldSizeMax = "common.field_size_max"
    case fieldSizeMin = "common.field_size_min"
    case fieldInvalidLength = "common.field_invalid_length"
    case fieldNotValidChars = "common.field_not_valid_chars"
    case fieldNumberMax = "common.field_max"
    case fieldNumberMin = "common.field_min"
    case fieldFuture = "common.field_future"
    case fieldPast = "common.field_past"
    case emailNotValid = "common.field_email"
    case cardNumberNotValid = "common.field_card_number"
    case phoneNumberNotValid = "common.field_phone"
    case fieldDuplicate = "common.field_duplicate"
    case unknown = "unknown"

    public init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(String.self) {
            self = LeoApiCodes(rawValue: value) ?? .unknown
        } else {
            self = .unknown
        }
    }
    
    public var isAccessTokenError: Bool {
        if case .accessTokenInvalid = self {
            return true
        }
        
        if case .accessTokenExpired = self {
            return true
        }
                
        return false
    }
}
