import Foundation
import KeychainSwift


class KeychainStorage: KeyValueStorage {
    
    
    private let storage: KeychainSwift
    
    private enum StorageError: ErrorObjectProvider {
        case code(OSStatus)
        case typeUnsupported(Any)
        
        var object: Swift.Error {
            let result = ErrorObject(domain: "KeychainStorage")
            
            switch self {
            case let .code(code):
                result.desc = "Internal error code: \(code)"
                
            case let .typeUnsupported(type):
                result.desc = "\"\(type)\" type unsuported"
            }
            return result
        }
    }
    
    //MARK: - Lifecycle
    init(prefix: String, icloud: Bool) {
        //Divide prefix and future key
        let prefix = prefix + "_"
        self.storage = KeychainSwift(keyPrefix: prefix)
        self.storage.synchronizable = icloud
    }
    
    
    
    //MARK: - KeyValueStorage
    func setValue(_ value: Any?, forKey key: KeyValueStorageKey) throws {
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
            throw StorageError.typeUnsupported(type(of: value!)).object
        }
        
        
        let code = self.storage.lastResultCode
        guard code == Darwin.noErr else {
            throw StorageError.code(code).object
        }
    }
    
    
    func getValue<T>(forKey key: KeyValueStorageKey, type: T.Type) throws -> T? {
        var result: T?
        
        switch type {
        case is Bool.Type:
            result = self.storage.getBool(key.rawValue) as? T
            
        case is Data.Type:
            result = self.storage.getData(key.rawValue) as? T
            
        case is String.Type:
            result = self.storage.get(key.rawValue) as? T
            
        default:
            throw StorageError.typeUnsupported(type.self).object
        }
        
        let code = self.storage.lastResultCode
        guard code == Darwin.noErr else {
            throw StorageError.code(code).object
        }
        
        return result
    }
    
    
   
}

