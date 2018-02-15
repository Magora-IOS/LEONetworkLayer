import Foundation



class UserDefaultsStorage: KeyValueStorage {
    
    private let storage: UserDefaults
    
    
    //MARK: - Lifecycle
    init(_ userDefaults: UserDefaults) {
        self.storage = userDefaults
    }
    
    
    //MARK: - KeyValueStorage
    func setValue(value: Any?, key: KeyValueStorageKey) -> Bool {
        self.storage.set(value, forKey: key.rawValue)
        return self.storage.synchronize()
    }
    
    
    func getValue(key: KeyValueStorageKey) -> Any? {
        return self.storage.value(forKey: key.rawValue)
    }
    
}

