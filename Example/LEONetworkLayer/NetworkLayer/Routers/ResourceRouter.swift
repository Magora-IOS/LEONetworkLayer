import Alamofire
import ObjectMapper



enum ResourceRouter: LEORouter {
    
    case generateUploadImageLink(contentType: String)
    
    
    var method: HTTPMethod {
        switch self {
        case .generateUploadImageLink:
            return .post
        }
    }
    
    
    var path: String {
        switch self {
        case .generateUploadImageLink:
            return "/resources"
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        return try createUrlWithParameters {
            switch self {
            case let .generateUploadImageLink(contentType):
                return ["contentType": contentType]
            }
        }
    }
}

