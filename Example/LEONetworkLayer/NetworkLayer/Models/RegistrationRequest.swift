import ObjectMapper

class RegistrationRequest: Mappable {
    
    var fullname: String = ""
    var email: String = ""
    var address: String = ""
    var birthday: Date?
    var phone: String?
    var password: String = ""
    
    var platform: String = "ios"
    var versionApp = "ios-app-v1"
        
    required init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        fullname <- map["fullName"]
        phone <- map["phoneNumber"]
        birthday <- map["dob"]
        address <- map["address"]
        password <- map["password"]
        
        platform <- map["meta.platform"]
        versionApp <- map["meta.versionApp"]
    }
}
