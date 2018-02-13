import Foundation



struct UserProfile {
    
    var id: String
    var name: String
    var email: String
    var phone: String?
    var birthDate: Date
    
    
    init() {
        id = ""
        name = ""
        email = ""
        phone = nil
        birthDate = Date()
    }
}

