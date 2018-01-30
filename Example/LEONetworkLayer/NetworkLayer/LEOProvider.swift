import Alamofire
import LEONetworkLayer

class LEOProvider {

    private let sessionManager: SessionManager
    
    var authHandler: AuthorizationHandler? {
        didSet {
            self.sessionManager.adapter = authHandler
            self.sessionManager.retrier = authHandler
        }
    }
    
    init() {
        //FIXME: //self.sessionManager = SessionManager.default
        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = [:]
        self.sessionManager = SessionManager(configuration: configuration)
        
    }
    
    init(authHandler: AuthorizationHandler) {
        self.sessionManager = SessionManager.default
        self.sessionManager.adapter = authHandler
        self.sessionManager.retrier = authHandler
    }
    
    init(withConfiguration configuration: URLSessionConfiguration) {
        self.sessionManager = SessionManager(configuration: configuration)
    }
    
    @discardableResult
    public func request<T:LEOBaseResponse>(
        router: LEORouter,
        completionHandler: @escaping (LEONetworkLayer.Response<T>) -> Void) -> DataRequest {
        
        return sessionManager
            .request(router)
            .logResponse(log: true)
            .validateLEOErrors()
            .responseLEO(completionHandler: completionHandler)
            .printRequestCURL()
    }
    
}

