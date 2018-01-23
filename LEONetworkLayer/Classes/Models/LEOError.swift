import ObjectMapper

enum LEOApiErrorCode: String {
    
    case unknown = "Unknown"
    case invalidAuthData = "sec.invalid_auth_data"
    case loginShouldBeConfirmed = "sec.login_should_be_confirmed"
    case refreshTokenInvalid = "sec.refresh_token_invalid"
    case accessTokenInvalid = "sec.access_token_invalid"
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
}


class LEOError: ImmutableMappable {
    
    let code: LEOApiErrorCode
    let message: String
    var field: String?
    

    
    required init(map: Map) throws {
        code = try map.value("code", using: EnumTransform<LEOApiErrorCode>())
        message = try map.value("message")
        field = try? map.value("field")
    }
    
    
}
