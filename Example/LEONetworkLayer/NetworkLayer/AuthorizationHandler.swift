import Foundation
import Alamofire
import LEONetworkLayer


class AuthorizationHandler: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?, _ accessTokenExpire: Date?) -> Void
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    
    private let lock = NSLock()
    private var authService: AuthService
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(authService: AuthService) {
        self.authService = authService
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
		
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            let isGet = urlRequest.httpMethod == HTTPMethod.get.rawValue
            let contentType = isGet ? "application/x-www-form-urlencoded" : "application/json"
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        if let accessToken = self.authService.authSession.accessToken {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        lock.lock()
        defer { lock.unlock() }
        
        let refreshTokenRouter = AuthRouter.refreshToken(refreshToken: String())
        let refreshRequest = sessionManager.request(refreshTokenRouter)
        let handlingRefreshFail = request.request?.url == refreshRequest.request?.url
        
        let loginRouter = AuthRouter.login(login: LEOLogInRequest())
        let loginRequest = sessionManager.request(loginRouter)
        let handlingLoginFail = request.request?.url == loginRequest.request?.url
        
        let handlingAuthRequestFail = handlingRefreshFail || handlingLoginFail

        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401,
            !handlingAuthRequestFail {
            
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                let authSession = authService.authSession
                authSession.accessToken = nil
                authService.authSession = authSession

                refreshTokens { [weak self] succeeded, accessToken, refreshToken, accessTokenExpire in
                    guard let strongSelf = self else { return }
                    strongSelf.lock.lock()
                    defer { strongSelf.lock.unlock() }
                    
                    authSession.accessToken = accessToken
                    authSession.refreshToken = refreshToken
                    authSession.accessTokenExpire = accessTokenExpire
                    DispatchQueue.main.async {
                        strongSelf.authService.authSession = authSession
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        if let refreshToken = self.authService.authSession.refreshToken {
            
            let refreshTokenRouter = AuthRouter.refreshToken(refreshToken: refreshToken)
            
            let request = sessionManager.request(refreshTokenRouter).responseObject { [weak self] (response: DataResponse<LEOObjectResponse<AuthSession>>) in
                guard let strongSelf = self else { return }
                
                switch response.result {
                case let .failure(error):
                    print(error.localizedDescription)
                    completion(false, nil, nil, nil)
                    break
                case let .success(value):
                    if let accessToken = value.data?.accessToken,
                        let refreshToken = value.data?.refreshToken,
                        let accessTokenExpire = value.data?.accessTokenExpire {
                        completion(true, accessToken, refreshToken, accessTokenExpire)
                    } else {
                        completion(false, nil, nil, nil)
                    }
                    break
                }
                strongSelf.isRefreshing = false
            }
            debugPrint(request)
        } else {
            DispatchQueue(label: "authHandler").async {
                [weak self] in
                completion(false, nil, nil, nil)
                self?.isRefreshing = false
            }
        }
    }
}
