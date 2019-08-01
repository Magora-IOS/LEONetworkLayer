import Foundation

enum LeoApiError: String, Codable, Error {
    
    case Unknown = "Unknown"
    case InvalidAuthData = "sec.invalid_auth_data"
    case LoginShouldBeConfirmed = "sec.login_should_be_confirmed"
    case RefreshTokenInvalid = "sec.refresh_token_invalid"
    case AccessTokenInvalid = "sec.access_token_invalid"
    case PassCodeNotValid = "sec.pass_code_not_valid"
    case InvalidPhoneCode = "sec.invalid_phone_code"
    
    case BusinessConflict = "business_conflict"
    case UnprocessableEntity = "unprocessable_entity"
    case BadParameters = "bad_parameters"
    case InternalError = "internal_error"
    case NotFound = "not_found"
    case SecurityError = "security_error"
    case PermissionError = "permission_error"
    
    case FieldNotBlank = "common.field_not_blank"
    case FieldSizeMax = "common.field_size_max"
    case FieldSizeMin = "common.field_size_min"
    case FieldInvalidLength = "common.field_invalid_length"
    case FieldNotValidChars = "common.field_not_valid_chars"
    case FieldNumberMax = "common.field_max"
    case FieldNumberMin = "common.field_min"
    case FieldFuture = "common.field_future"
    case FieldPast = "common.field_past"
    case EmailNotValid = "common.field_email"
    case CardNumberNotValid = "common.field_card_number"
    case PhoneNumberNotValid = "common.field_phone"
    case FieldDuplicate = "common.field_duplicate"
    
    case BadResponse
    
    var localizedDescription: String {
        return NSLocalizedString(("api.error." + rawValue), comment: "")
    }    
}
