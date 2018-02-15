import Foundation



protocol AuthStorage {
    var authSession: AuthSession { get set }
}



class AuthStorageImpl: AuthStorage {
    
    //MARK: - Properties
    private let storage: KeyValueStorage
    
    
    //MARK: - Lifecycle
    init(storage: KeyValueStorage) {
        self.storage = storage
    }

    
    //MARK: - Interface
    var authSession: AuthSession {
        get {
            var session = AuthSession()
            session.accessToken = self.storage.getValue(key: .authSessionAccessToken) as? String
            session.refreshToken = self.storage.getValue(key: .authSessionRefreshToken) as? String
            session.accessTokenExpire = self.storage.getValue(key: .authSessionAccessTokenExpirationDate) as? Date
            return session
        }
        set {
            self.storage.setValue(value: newValue.accessToken, key: .authSessionAccessToken)
            self.storage.setValue(value: newValue.refreshToken, key: .authSessionRefreshToken)
            self.storage.setValue(value: newValue.accessTokenExpire, key: .authSessionAccessTokenExpirationDate)
        }
    }
}
