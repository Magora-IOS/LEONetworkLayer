import Alamofire
import ObjectMapper



enum ProfileRouter: LEORouter {
    
    case getProfile(userId: Int)
  
    
    public var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get

        }
    }
    
    public var path: String {
        switch self {
        case let .getProfile(userId):
            return String(format: "/Users/%d", userId)  //"/profiles/my"
        }
    }
    
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        return try self.createUrlWithParameters {
            switch self {
           
            default:
                return [:]
            }
        }
    }
}

