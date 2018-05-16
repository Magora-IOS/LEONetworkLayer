import ObjectMapper
import LEONetworkLayer


struct UserProfileDTO: ImmutableMappable {
    
    var id: String
    var name: String
    var email: String
    var phone: String?
    var birthDate: Date
    

    
    init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("fullName")
        email = try map.value("email")
        phone = try map.valueOrNil("phoneNumber")
        birthDate = try map.value("dob", using: DateTransformISO8601())
    }
    
    
    func mapping(map: Map) {
        name >>> map["fullName"]
        email >>> map["email"]
        phone >>> map["phoneNumber"]
        birthDate >>> (map["dob"], DateTransformISO8601())
    }

}





extension UserProfileDTO {
    
    init(object: UserProfile) {
        id = object.id
        name = object.name
        email = object.email
        phone = object.phone
        birthDate = object.birthDate
    }
    
}
