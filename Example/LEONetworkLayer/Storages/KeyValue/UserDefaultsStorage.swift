import Foundation



class UserDefaultsStorage: KeyValueStorage {
  
    
    private let storage: UserDefaults
    
    
    //MARK: - Lifecycle
    init(_ userDefaults: UserDefaults) {
        self.storage = userDefaults
    }
    
    
    //MARK: - KeyValueStorage
    func setValue(_ value: Any?, forKey key: KeyValueStorageKey) throws {
        self.storage.set(value, forKey: key.rawValue)
        self.storage.synchronize()
    }
    
    
    func getValue<T>(forKey key: KeyValueStorageKey, type: T.Type) throws -> T? {
        return self.storage.value(forKey: key.rawValue) as? T
    }
    
}

