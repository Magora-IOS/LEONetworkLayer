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
            var session: AuthSession?
            let sessionString = getValue(forKey: "session") as? String
            if sessionString != nil {
                session = AuthSession(JSONString: sessionString!)
            }
            guard session != nil else {
                return AuthSession()
            }
            return session!
        }
        set {
            let sessionString = newValue.toJSONString()
            setValue(value: sessionString, forKey: "session")
        }
    }
    
    
    var userId: String? {
        get {
            return getValue(forKey: "userId") as? String
        }
        set {
            setValue(value: newValue, forKey: "userId")
        }
    }
}
