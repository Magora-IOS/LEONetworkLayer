import Alamofire
import LEONetworkLayer



class LEOProvider {
    
    //MARK: - Properties
    private let sessionManager: SessionManager
    
    var authHandler: AuthorizationHandler? {
        didSet {
            self.sessionManager.adapter = authHandler
            self.sessionManager.retrier = authHandler
        }
    }
    
    
    
    //MARK: - Lifecycle
    init(withConfiguration configuration: URLSessionConfiguration) {
        self.sessionManager = SessionManager(configuration: configuration)
    }
    
    
    
    
    //MARK: - Request
    @discardableResult
    public func request<T:LEOBaseResponse>(
        router: LEORouter,
        completionHandler: @escaping (LEONetworkLayer.Response<T>) -> Void)
        -> DataRequest {
            
            return self.sessionManager
                .request(router)
                .leo_logRequestCURL { Log($0) }
                .leo_logResponse{ Log($0) }
                .leo_validateResponse()
                .leo_mapResponse(completionHandler: completionHandler)
    }
    
}

