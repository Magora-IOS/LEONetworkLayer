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
            do {
                session.accessToken = try self.storage.getValue(forKey: .authSessionAccessToken, type: String.self)
                session.refreshToken = try self.storage.getValue(forKey: .authSessionRefreshToken, type: String.self)
                session.accessTokenExpire = try self.storage.getValue(forKey: .authSessionAccessTokenExpirationDate, type: Date.self)
            } catch {
                //Error is ignored, cant throw from property
                //TODO: rethrow error
                Log(error)
            }
            return session
        }
        set {
            do {
                try self.storage.setValue(newValue.accessToken, forKey: .authSessionAccessToken)
                try self.storage.setValue(newValue.refreshToken, forKey: .authSessionRefreshToken)
                try self.storage.setValue(newValue.accessTokenExpire, forKey: .authSessionAccessTokenExpirationDate)
            } catch {
                //Error is ignored, cant throw from property
                //TODO: rethrow error
                Log(error)
            }
        }
    }
}
