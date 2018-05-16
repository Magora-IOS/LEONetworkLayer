import Alamofire
import ObjectMapper
import LEONetworkLayer



enum AuthRouter: LEORouter {
    
    case signUp(SignUpRequest)
    case signIn(SignInRequest)
    case refreshToken(String)
	case resetPassword(email: String)
    case createNewPassword(code: String, password: String)
    
    
    var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        case .signIn:
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
        case .signUp:
            return "/auth"
        case .signIn:
            return "/auth/token"
        case .refreshToken:
            return "/auth/token"
		case .resetPassword:
			return "/auth/reset"
        case .createNewPassword(let code, _):
            return "/auth/reset-password/\(code)"
        }
    }
    
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        return try self.createUrlWithParameters {
            switch self {
            case let .signUp(data):
                return data.toJSON()
                
            case let .signIn(login):
                return login.toJSON()
                
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

