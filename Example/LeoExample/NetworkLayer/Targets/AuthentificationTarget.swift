import Foundation
import LEONetworkLayer
import Moya

enum AuthentificationTarget {
    case sendPhone(phone: String)
    case login(login: TokenRequestParameters)
    case refreshToken(refreshToken: String)
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendPhone, .login:
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
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        case .login:
            return .none
        default:
            return self.authorization
        }        
    }
    
    var sampleData: Data {
        switch self {
            case .sendPhone:
                let mockResponse = """
                    {"data": {
                        "signUp": false            
                        },
                     "code":"not_found"}
                    """
                return mockResponse.data(using: .utf8)!
            default:
                    return Data()
        }
    }
}
