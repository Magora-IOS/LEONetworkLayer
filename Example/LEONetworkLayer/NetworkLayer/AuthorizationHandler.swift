import Foundation
import Alamofire
import LEONetworkLayer
import RxSwift



class AuthorizationHandler: RequestAdapter, RequestRetrier {
    
    //MARK: - Properties
    private typealias RefreshCompletion = (_ succeeded: Bool) -> Void
    
    
    private let lock = NSLock()
    private let authService: AuthService
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    private let disposeBag = DisposeBag()
    
    
    
    //MARK: - Initialization
    public init(authService: AuthService) {
        self.authService = authService
    }
    
    
    
    //MARK: - RequestAdapter
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard !self.isRefresh(urlRequest) else {
            return urlRequest
        }
        
        var result = urlRequest
        if let accessToken = self.authService.authSession.accessToken {
            result.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        return result
    }
    
    
    
    //MARK: - RequestRetrier
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        self.lock.lock()
        defer { self.lock.unlock() }
        
        guard self.isUnauthorized(request) else {
            completion(false, 0.0)
            return
        }
        
        self.requestsToRetry.append(completion)
        
        
        if !self.isRefreshing {
            self.refreshToken { [weak self] succeeded in
                guard let strongSelf = self else { return }
                strongSelf.lock.lock()
                defer { strongSelf.lock.unlock() }
                
                strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                strongSelf.requestsToRetry.removeAll()
            }
        }
    }
    
    
    
    //MARK: - Private - Refresh Tokens
    private func refreshToken(completion: @escaping RefreshCompletion) {
        guard !self.isRefreshing else { return }
        self.isRefreshing = true
        
        
        self.authService.refreshSession()
            .do(
                onNext: { _ in
                    completion(true)
            },
                onError: {
                    Log($0)
                    completion(false)
            },
                onCompleted: { [weak self] in
                    self?.isRefreshing = false
                }
            )
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    
    
    //MARK: - Routines
    private func isRefresh(_ request: URLRequest?) -> Bool {
        return AuthRouter.refreshToken("").fullUrl.absoluteURL == request?.url
    }
    
    
    private func isLogin(_ request: URLRequest?) -> Bool {
        return AuthRouter.signIn(SignInRequest()).fullUrl.absoluteURL == request?.url
    }
    
    
    private func isUnauthorized(_ request: Request) -> Bool {
        //Returns true only for cases where regular request have "unauthorized" response
        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401,
            !self.isRefresh(request.request),
            !self.isLogin(request.request)  {
            return true
        }
        else {
            return false
        }
    }
}

