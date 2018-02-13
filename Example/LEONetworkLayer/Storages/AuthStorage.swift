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
            return session
        }
        set {
            setValue(value: newValue.accessToken, forKey: "accessToken")
            setValue(value: newValue.refreshToken, forKey: "refreshToken")
            setValue(value: newValue.accessTokenExpire, forKey: "accessTokenExpire")
        }
    }
}
