import ObjectMapper

class CreatePasswordResponse: Mappable {
    
    var codeValid: Bool!
    
    required init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        codeValid <- map["codeValid"]
    }
}

