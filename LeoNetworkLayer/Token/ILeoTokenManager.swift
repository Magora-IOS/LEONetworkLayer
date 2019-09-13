import RxSwift
import Moya

public protocol ILeoTokenManager {
    /**
     Returns the access token
     */
    func getAccessToken() -> String

    /**
     Get and update access and refresh tokens.
     If result is nil, refresh token is disabled, in case authorization error occurs clearTokensAndHandleLogout() is called
     */
    func getNewTokens() -> Completable?
    
    /**
     Number of refresh token attemts (min - 0, max - 10)
     After exhausting the number of attempts, clearTokensAndHandleLogout() will be called
     0 means refresh token is disabled, but if authorization error occurs clearTokensAndHandleLogout() is called
     */
    var numberRefreshTokenAttempts: Int { get }

    /**
     Сalled after token update failure
     */
    func clearTokensAndHandleLogout()
}


