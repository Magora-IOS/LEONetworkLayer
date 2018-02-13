import ObjectMapper

class ResetPasswordResponse: Mappable {
	
	var emailFound: Bool!
	
	required init() {}
	required init?(map: Map) {}
	
	func mapping(map: Map) {
		emailFound <- map["emailFound"]
	}
}
