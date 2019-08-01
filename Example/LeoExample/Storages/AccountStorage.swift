import Foundation

protocol IAccountStorage {
    var deviceID: String {get set}
    var userID: String? {get set}
    var accessToken: String? {get set}
    var refreshToken: String? {get set}
    var pushToken: String? {get set}
}

class AccountStorage: IAccountStorage {
    private let storage: IKeychainStorage
    
    // MARK: - Keys
    enum Keys: String {
        case deviceID
        case userID
        case accessToken
        case refreshToken
        case pushTokenKey
    }
    
    var deviceID: String {
        didSet {
            self.storage.setValue(value: deviceID, forKey: Keys.deviceID.rawValue)
        }
    }
    var userID: String? {
        didSet {
            self.storage.setValue(value: userID, forKey: Keys.userID.rawValue)
        }
    }
    var accessToken: String? {
        didSet {
            self.storage.setValue(value: accessToken, forKey: Keys.accessToken.rawValue)
        }
    }
    var refreshToken: String? {
        didSet {
            self.storage.setValue(value: refreshToken, forKey: Keys.refreshToken.rawValue)
        }
    }
    var pushToken: String? {
        didSet {
            self.storage.setValue(value: pushToken, forKey: Keys.pushTokenKey.rawValue)
        }
    }
    
    
    // MARK: - Init
    init(storage: IKeychainStorage) {
        self.storage = storage
        
        userID = self.storage.getValue(forKey: Keys.userID.rawValue, type: String.self)
        accessToken = self.storage.getValue(forKey: Keys.accessToken.rawValue, type: String.self)
        refreshToken = self.storage.getValue(forKey: Keys.refreshToken.rawValue, type: String.self)
        pushToken = self.storage.getValue(forKey: Keys.pushTokenKey.rawValue, type: String.self)
        
        if let id = self.storage.getValue(forKey: Keys.deviceID.rawValue, type: String.self) {
            deviceID = id
        } else {
            deviceID = NSUUID().uuidString
        }
    }
    
    
}
