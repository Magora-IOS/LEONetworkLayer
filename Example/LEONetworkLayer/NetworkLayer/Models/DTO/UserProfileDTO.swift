import ObjectMapper
import LEONetworkLayer


class UserProfileDTO: Mappable {
    
    var id: Int?
    var name: String?
    var email: String?
    var address: String?
    var phone: String?
    var birthDate: Date?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["fullName"]
        email <- map["email"]
        address <- map["address"]
        phone <- map["phoneNumber"]
        birthDate <- (map["dob"], DateTransformISO8061())
    }

}
