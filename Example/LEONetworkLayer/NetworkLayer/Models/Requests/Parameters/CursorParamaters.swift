import ObjectMapper





class CursorParameters: Mappable {
    
    var cursor: String
    var size: Int
    
    
    required init?(map: Map) {
        return nil
    }
    
    func mapping(map: Map) {
        cursor <- map["cursor"]
        size <- map["pageSize"]
    }
    
    init(cursor: String, size: Int) {
        self.cursor = cursor
        self.size = size
    }
}
