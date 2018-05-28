import Alamofire
import ObjectMapper
import LEONetworkLayer



enum CollectionRouter: LEORouter {
    
    case items
    case itemsPage(PageParameters)
    case itemsCursor(CursorParameters)
    
    
    var method: HTTPMethod {
        switch self {
        case .items:
            return .get
        case .itemsPage:
            return .get
        case .itemsCursor:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .items:
            return "/items"
        case .itemsPage:
            return "/items/page"
        case .itemsCursor:
            return "/items/seek"
        }
    }
    
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        return try self.createUrlWithParameters {
            switch self {
            case .items:
                return nil
                
            case let .itemsPage(params):
                return params.toJSON()
                
            case let .itemsCursor(params):
                return params.toJSON()
            }
        }
    }
}

