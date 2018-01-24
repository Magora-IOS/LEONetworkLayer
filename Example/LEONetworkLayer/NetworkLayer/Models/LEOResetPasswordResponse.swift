import ObjectMapper

class LEOResetPasswordResponse: Mappable {
	
	var emailFound: Bool!
	
	required init() {}
	required init?(map: Map) {}
	
	func mapping(map: Map) {
		emailFound <- map["emailFound"]
	}
}
