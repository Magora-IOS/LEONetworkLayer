import Foundation
import LEONetworkLayer
import Moya

enum AuthentificationTarget {
    case sendPhone(phone: String)
    case login(login: TokenRequestParameters)
    case refreshToken(refreshToken: String)
    case register(data: UserRegistrationInfoDTO)
}

extension AuthentificationTarget: ILeoTargetType {
    var path: String {
        switch self {
        case .sendPhone:
            return "/tokens/codes"
        case .login:
            return "/tokens/sms"
        case .refreshToken:
            return "/tokens"
        case .register:
            return "/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendPhone, .login, .register:
            return .post
        case .refreshToken:
            return .put
        }
    }

    var task: Task {
        switch self {
        case .sendPhone(let phone):
            return .requestParameters(parameters: ["phone":phone], encoding: JSONEncoding.default)
        case .login(let loginData):
            return .requestJSONEncodable(loginData)
        case .refreshToken(let refreshToken):
            return .requestParameters(parameters: ["refreshToken": refreshToken], encoding: JSONEncoding.default)
        case .register(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        case .register:
            return self.authorization
        default:
            return .none
        }
    }
    
    var sampleData: Data {
        switch self {
            case .sendPhone:
                return LeoMockResponse.success(value: #" "signUp": false "#)
            default:
                return LeoMockResponse.emptySuccess
        }
    }
}
