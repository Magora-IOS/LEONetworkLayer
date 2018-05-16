import RxSwift
import RxCocoa
import ObjectMapper
import LEONetworkLayer




protocol AuthService {
    var isAuth: Bool { get }
    var authorised: BehaviorRelay<Bool> { get }
 
    var authSession: AuthSession { get set }
    var logoutHandler: (() -> Void)? { get set }

    func signIn(login: String, password: String) -> Observable<AuthSession>
    func signUp(data: SignUpRequest) -> Observable<AuthSession>
	func resetPassword(email: String) -> Observable<ResetPasswordResponse>
    func createNewPassword(code: String, password: String) -> Observable<CreatePasswordResponse>
    func refreshSession() -> Observable<AuthSession>
    func signOut()
}



class AuthServiceImpl: AuthService, RxRequestService {
    
    
    
    private enum ServiceError: ErrorObjectProvider {
        case method(String, Swift.Error)
        case noRefreshToken
        
        var object: Swift.Error {
            let result = ErrorObject(domain: "AuthService")
            
            switch self {
            case let .method(name, error):
                result.desc = "\"\(name)\" action failed"
                result.underlyingError = error
                
            case .noRefreshToken:
                result.desc = "No refresh token saved"
            }
            return result
        }
    }
    
    
    //MARK: - Properties
    let apiProvider: LEOProvider
    var authStorage: AuthStorage
    var logoutHandler: (() -> Void)?
    var authorised: BehaviorRelay<Bool>
    
   
    
    //MARK: - Lifecycle
    init(apiProvider: LEOProvider, authStorage: AuthStorage) {
        self.apiProvider = apiProvider
        self.authStorage = authStorage
        self.authorised = BehaviorRelay(value: authStorage.authSession.accessToken != nil)

    }
    
    
    //MARK: - Properties (computable)
    var isAuth: Bool {
        return self.authorised.value
    }
    
    
    var authSession: AuthSession {
        set(newValue) {
            self.authStorage.authSession = newValue
            if (newValue.accessToken == nil || newValue.accessToken?.count == 0) {
                self.logoutHandler?()
            }
        }
        get {
            return self.authStorage.authSession
        }
    }
    
    
    //MARK: - Requests
    func signIn(login: String, password: String) -> Observable<AuthSession> {
        let data = SignInRequest(login: login, password: password)
        let router = AuthRouter.signIn(data)
        return self.createObserver(type: LEOObjectResponse<AuthSessionDTO>.self, router: router)
            .map {
                AuthSession(dto: $0.data)
            }
            .catchError {
                Observable.error(ServiceError.method("Sign In", $0).object)
            }
            .do(
                onNext: { [weak self] authSession in
                    self?.saveSession(authSession)
                    self?.authorised.accept(true)
                }
            )
    }
    
    
    func signUp(data: SignUpRequest) -> Observable<AuthSession> {
        let router = AuthRouter.signUp(data)
        return self.createObserver(type: LEOObjectResponse<AuthSessionDTO>.self, router: router)
            .map {
                AuthSession(dto: $0.data)
            }
            .catchError {
                Observable.error(ServiceError.method("Sign Up", $0).object)
            }
            .do(
                onNext: { [weak self] authSession in
                    self?.saveSession(authSession)
                    self?.authorised.accept(true)
                }
            )
    }
    
    
    func signOut() {
        self.clearSession()
        self.authorised.accept(false)
    }

    
	func resetPassword(email: String) -> Observable<ResetPasswordResponse> {
		let router = AuthRouter.resetPassword(email: email)
		return self.createObserver(type: LEOObjectResponse<ResetPasswordResponse>.self, router: router)
            .map {
                $0.data
            }
            .catchError {
                Observable.error(ServiceError.method("Reset password", $0).object)
            }
	}
    
    
    func createNewPassword(code: String, password: String) -> Observable<CreatePasswordResponse> {
        let router = AuthRouter.createNewPassword(code: code, password: password)
        return self.createObserver(type: LEOObjectResponse<CreatePasswordResponse>.self, router: router)
            .map {
                $0.data
            }
            .catchError {
                Observable.error(ServiceError.method("Create new password", $0).object)
            }
    }
    
    
    
    func refreshSession() -> Observable<AuthSession> {
        guard let token = self.authSession.refreshToken else {
            return Observable.error(ServiceError.noRefreshToken.object)
        }
        
        let router = AuthRouter.refreshToken(token)
        return self.createObserver(type: LEOObjectResponse<AuthSessionDTO>.self, router: router)
            .map {
                AuthSession(dto: $0.data)
            }
            .catchError {
                Observable.error(ServiceError.method("Refresh token", $0).object)
            }
            .do(
                onNext: { [weak self] authSession in
                    self?.saveSession(authSession)
                }
        )
    }
    
	
    
    //MARK: - Private
    private func saveSession(_ authSession: AuthSession) {
        self.authStorage.authSession = authSession
    }
    
    
    private func clearSession() {
        var session = AuthSession()
        session.accessToken = nil
        session.refreshToken = nil
        session.accessTokenExpire = nil
        session.authInfo = nil
        self.authStorage.authSession = session
    }
}
