import RxSwift
import ObjectMapper
import LEONetworkLayer

#if DEBUG
    import OHHTTPStubs
#endif

protocol AuthService {
    var isAuth: Bool { get }
    var authorised: Variable<Bool> { get }
    var currentUserID: Int? { get }
    var authSession: AuthSession { get set }
    var logoutHandler: (() -> Void)? {get set}

    func signin(login: String, password: String) -> Observable<AuthSession>
    func registration(reg: LEORegistrationRequest) -> Observable<AuthSession>
	func resetPassword(email: String) -> Observable<LEOResetPasswordResponse>
    func createNewPassword(code: String, password: String) -> Observable<LEOCreatePasswordResponse>
    func signout()
}

class AuthServiceImp: AuthService, RxRequestService {
    
    let apiProvider: LEOProvider
    var authStorage: AuthStorage
    var profileStorage: UserProfileStorage
    var logoutHandler: (() -> Void)?
    var authorised: Variable<Bool>
    
    #if DEBUG
    private weak var resetPassword: OHHTTPStubsDescriptor?
    private weak var createPassword: OHHTTPStubsDescriptor?
    #endif
    
    init(apiProvider: LEOProvider, authStorage: AuthStorage, profileStorage: UserProfileStorage) {
        self.apiProvider = apiProvider
        self.authStorage = authStorage
        self.profileStorage = profileStorage
        self.authorised = Variable(authStorage.authSession.accessToken != nil)
        
        #if DEBUG
            setupStubs()
        #endif
    }
    
    
    #if DEBUG
    func setupStubs() {
        resetPassword = stub(condition: {request in
            if request.url?.lastPathComponent == "reset" {
                return true
            }
            return false
        }) { (request) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("ResetPasswordStub.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        resetPassword?.name = "ResetPassword stub"
        
        createPassword = stub(condition: {request in
            if request.url?.lastPathComponent == "090" {
                return true
            }
            return false
        }) { (request) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("ResetPasswordStub.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        createPassword?.name = "createPassword stub"
    }
    #endif
    
    var isAuth: Bool {
        return self.authorised.value
    }
    
    var currentUserID: Int? {
        return authSession.authInfo.id
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
    
    func signin(login: String, password: String) -> Observable<AuthSession> {
        
        let login = LEOLogInRequest(login: login, password: password)
        let router = AuthRouter.login(login: login)
        return createObserver(type: LEOObjectResponse<AuthSession>.self, router: router)
            .map({ (response) in
                guard let authSession = response.data else {
                    throw LEONetworkLayerError.badResponse
                }
                return authSession
            })
            .do(onNext: { [weak self] (authSession) in
                self?.saveSession(authSession: authSession)
                self?.authorised.value = true
            })
    }
    
    func registration(reg: LEORegistrationRequest) -> Observable<AuthSession> {
        
        let router = AuthRouter.registration(data: reg)
        return createObserver(type: LEOObjectResponse<AuthSession>.self, router: router)
            .map({ (response) in
                guard let authSession = response.data else {
                    throw LEONetworkLayerError.badResponse
                }
                return authSession
            })
            .do(onNext: { [weak self] (authSession) in
                self?.saveSession(authSession: authSession)
                self?.authorised.value = true
            })
    }
    
    func signout() {
        clearSession()
        self.authorised.value = false
    }

	func resetPassword(email: String) -> Observable<LEOResetPasswordResponse> {
		let router = AuthRouter.resetPassword(email: email)
		return createObserver(type: LEOObjectResponse<LEOResetPasswordResponse>.self, router: router)
            .map({ (response) in
                guard let resetPasswordResponse = response.data else {
                    throw LEONetworkLayerError.badResponse
                }
                return resetPasswordResponse
            })
	}
    
    func createNewPassword(code: String, password: String) -> Observable<LEOCreatePasswordResponse> {
        let router = AuthRouter.createNewPassword(code: code, password: password)
        return createObserver(type: LEOObjectResponse<LEOCreatePasswordResponse>.self, router: router)
            .map({ (response) in
                guard let createPasswordResponse = response.data else {
                    throw LEONetworkLayerError.badResponse
                }
                return createPasswordResponse
            })
    }
	
    // MARK: Private
    
    private func saveSession(authSession: AuthSession) {
        self.authStorage.authSession = authSession
        profileStorage.save(profile: authSession.authInfo.object())
    }
    
    private func clearSession() {
        let session = AuthSession()
        session.accessToken = nil
        session.refreshToken = nil
        session.accessTokenExpire = nil
        self.authStorage.authSession = session
    }
}
