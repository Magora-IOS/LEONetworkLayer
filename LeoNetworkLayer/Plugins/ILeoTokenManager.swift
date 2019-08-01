import RxSwift
import Moya

public protocol ILeoTokenManager {
    var refreshTokenTimeout: TimeInterval {get}
    func getAccessToken() -> String
    func getRefreshToken() -> String
    func refreshToken() -> Single<Moya.Response>?
    func clearTokensAndHandleLogout()
}


