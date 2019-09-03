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
            return .requestJSONEncodable(SendPhoneRequestParameters(phone: phone))
        case .login(let loginData):
            return .requestJSONEncodable(loginData)
        case .refreshToken(let refreshToken):
            return .requestJSONEncodable(RefreshTokenRequestParameters(refreshToken: refreshToken))
        case .register(let data):
            return .requestJSONEncodable(data)
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .register:
            return self.defaultLeoAuthorization
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
