import Alamofire
import ObjectMapper
import LEONetworkLayer



enum AuthRouter: LEORouter {
    
    case registration(data: LEORegistrationRequest)
    case login(login: LEOLogInRequest)
    case refreshToken(refreshToken: String)
	case resetPassword(email: String)
    case createNewPassword(code: String, password: String)
    
    var method: HTTPMethod {
        switch self {
        case .registration:
            return .post
        case .login:
            return .post
        case .refreshToken:
            return .put
		case .resetPassword:
			return .post
        case .createNewPassword:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .registration:
            return "/Users"
        case .login:
            return "/Users/login"
        case .refreshToken:
            return "/auth/token"
		case .resetPassword:
			return "/Users/reset"
        case .createNewPassword(let code, _):
            return "/Users/reset-password/\(code)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        return try createUrlWithParametrs {
            switch self {
            case let .registration(data):
                return data.toJSON()
            case let .login(login):
                return login.toJSON().merging(["include[1]" : "user"], uniquingKeysWith: { (current, _) -> Any in current })
            case .refreshToken(let refreshToken):
                return ["refreshToken": refreshToken]
			case .resetPassword(let email):
				return ["email": email]
            case .createNewPassword(_, let password):
                return ["newPassword": password]
            }
        }
    }
}

class AuthSession: Mappable {
    
    var refreshToken: String?
    var accessToken: String?
    var accessTokenExpire: Date?
    var authInfo = UserProfileDTO()
	
	init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        accessToken <- map["accessToken"]
        accessTokenExpire <- (map["accessTokenExpire"], DateTransformMiliseconds())
        refreshToken <- map["refreshToken"]
        authInfo <- map["authInfo"]
    }
    
}
