import Foundation

protocol KVStorage {
    func setValue(value: Any?, forKey: String)
    func getValue(forKey: String) -> Any?
}

protocol AuthStorage {
    var authSession: AuthSession { get set }
}

class UserDefaultsStorage : KVStorage {
    
    init() {}
    
    func setValue(value: Any?, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    func getValue(forKey: String) -> Any? {
        return UserDefaults.standard.value(forKey: forKey)
    }
}



extension UserDefaultsStorage: AuthStorage {
    
    var authSession: AuthSession {
        get {
            var session = AuthSession()
            session.accessToken = getValue(forKey: "accessToken") as? String
            session.refreshToken = getValue(forKey: "refreshToken") as? String
            session.accessTokenExpire = getValue(forKey: "accessTokenExpire") as? Date
            session.authInfo = self.authInfo
            return session
        }
        set {
            setValue(value: newValue.accessToken, forKey: "accessToken")
            setValue(value: newValue.refreshToken, forKey: "refreshToken")
            setValue(value: newValue.accessTokenExpire, forKey: "accessTokenExpire")
            self.authInfo = newValue.authInfo
        }
    }
    
    
    private var authInfo: AuthInfo? {
        get {
            var info = AuthInfo()
            info.displayName = getValue(forKey: "displayName") as? String
            info.userId = getValue(forKey: "userId") as? String
            return info
        }
        set {
            setValue(value: newValue?.displayName, forKey: "displayName")
            setValue(value: newValue?.userId, forKey: "userId")
        }
    }
}
