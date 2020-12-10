import Foundation
import LEONetworkLayer
import Moya

enum AuthentificationTarget {
    case sendPhone(_ phone: SendPhoneRequestParameters)
    case login(_ login: TokenRequestParameters)
    case refreshToken(_ refreshToken: RefreshTokenRequestParameters)
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
            return .requestJSONEncodable(phone)
        case .login(let loginData):
            return .requestJSONEncodable(loginData)
        case .refreshToken(let refreshToken):
            return .requestJSONEncodable(refreshToken)
        case .register(let data):
            return .requestJSONEncodable(data)
        }
    }

    var authorizationType: AuthorizationType? {
        switch self {
        case .sendPhone, .login, .refreshToken:
            return nil
        default:
            return self.defaultLeoAuthorization
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
