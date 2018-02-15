import Foundation
import KeychainSwift


class KeychainStorage: KeyValueStorage {
    
    
    private let storage: KeychainSwift
    
    
    //MARK: - Lifecycle
    init(prefix: String, icloud: Bool) {
        self.storage = KeychainSwift(keyPrefix: prefix)
        self.storage.synchronizable = icloud
    }
    
    
    //MARK: - KeyValueStorage
    func setValue(value: Any?, key: KeyValueStorageKey) -> Bool {
        if let string = value as? String {
            self.storage.set(string, forKey: key.rawValue)
        }
        else if let bool = value as? Bool {
            self.storage.set(bool, forKey: key.rawValue)
        }
        else if let data = value as? Data {
            self.storage.set(data, forKey: key.rawValue)
        }
        else if value == nil {
            self.storage.delete(key.rawValue)
        }
        else {
            return false
        }
        
        return self.storage.lastResultCode == noErr
    }
    
    
    func getValue(key: KeyValueStorageKey) -> Any? {
        if let string = self.storage.get(key.rawValue) {
            return string
        }
        else if let bool = self.storage.getBool(key.rawValue) {
            return bool
        }
        else if let data = self.storage.getData(key.rawValue) {
            return data
        }
        else {
            return nil
        }
    }
    
    
}

