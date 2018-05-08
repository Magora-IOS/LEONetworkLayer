import Alamofire
import ObjectMapper



enum ProfileRouter: LEORouter {
    
    case getProfile(userId: Int)
    case updateAvatar(resourceId: String)
    
    
    public var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get

        case .updateAvatar:
            return .put
        }
    }
    
    public var path: String {
        switch self {
        case let .getProfile(userId):
            return "/users/\(userId)"
            
        case .updateAvatar:
            return "/user/profile/avatar"
        }
    }
    
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        return try self.createUrlWithParameters {
            switch self {
            case .getProfile:
                return nil
                
            case let .updateAvatar(resourceId):
                return ["resourceId": resourceId]
            }
        }
    }
}

