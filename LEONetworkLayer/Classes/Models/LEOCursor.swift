import ObjectMapper



class LEOCursor: Mappable {
    
    var cursor: String?
    var pageSize: Int = 10
    var query: String?
	
	var isEndReached: Bool = false
    
    init(cursor: String? = nil, pageSize: Int = 10, query: String? = nil) {
        self.cursor = cursor
        self.pageSize = pageSize
        self.query = query
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        cursor <- map["cursor"]
        pageSize <- map["pageSize"]
        query <- map["query"]
    }
}
