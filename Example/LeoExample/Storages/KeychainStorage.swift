import Foundation
import KeychainSwift

protocol IKeychainStorage {
    func setValue(value: Any?, forKey: String)
    func getValue(forKey: String) -> Any?
    func getValue<T>(forKey key: String, type: T.Type) -> T?
}

class KeychainStorage: IKeychainStorage {
    
    private let storage: KeychainSwift
    
    //MARK: - Lifecycle
    
    init(prefix: String, icloud: Bool) {
        self.storage = KeychainSwift(keyPrefix: prefix)
        self.storage.synchronizable = icloud
    }
    
    //MARK: - KeyValueStorage
    
    func setValue(value: Any?, forKey key: String) {
        if let string = value as? String {
            self.storage.set(string, forKey: key)
        }
        else if let bool = value as? Bool {
            self.storage.set(bool, forKey: key)
        }
        else if let data = value as? Data {
            self.storage.set(data, forKey: key)
        }
        else if value == nil {
            self.storage.delete(key)
        }
    }
    
    
    func getValue(forKey key: String) -> Any? {
        if let string = self.storage.get(key) {
            return string
        }
        else if let bool = self.storage.getBool(key) {
            return bool
        }
        else if let data = self.storage.getData(key) {
            return data
        }
        else {
            return nil
        }
    }
    
    func getValue<T>(forKey key: String, type: T.Type) -> T? {
        switch type {
        case is Bool.Type:
            return self.storage.getBool(key) as? T
        case is Data.Type:
            return self.storage.getData(key) as? T
        case is String.Type:
            return self.storage.get(key) as? T
        default:
            return nil
        }
    }
}
