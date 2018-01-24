import Foundation
import RealmSwift



class UserProfile: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var email: String?
    @objc dynamic var address: String?
    @objc dynamic var phone: String?
    @objc dynamic var nationality: String?
    @objc dynamic var birthDate: Date?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
    public func birthDateString() -> String? {
        var result : String?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let bDate = birthDate {
            result = dateFormatter.string(from: bDate)
        }
        
        return result
    }
    
}


extension UserProfileDTO {
    convenience init(object: UserProfile) {
        self.init()
        self.id = object.id
        self.name = object.name
        self.email = object.email
        self.address = object.address
        self.phone = object.phone
        self.birthDate = object.birthDate
    
    }
    
    func object() -> UserProfile {
        let object = UserProfile()
        object.id = id ?? 0
        object.name = name
        object.email = email
        object.address = address
        object.phone = phone
        object.birthDate = birthDate
        return object
    }
}

