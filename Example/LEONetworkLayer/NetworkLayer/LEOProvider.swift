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
    init() {
        let configuration = URLSessionConfiguration.default
        self.sessionManager = SessionManager(configuration: configuration)
    }
    
    
    init(withConfiguration configuration: URLSessionConfiguration) {
        self.sessionManager = SessionManager(configuration: configuration)
    }
    
    
    
    //MARK: - Interface
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

