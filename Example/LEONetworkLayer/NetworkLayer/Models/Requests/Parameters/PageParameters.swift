import ObjectMapper






class PageParameters: Mappable {
    
    var current: Int
    var size: Int
    
    
    required init?(map: Map) {
        return nil
    }
    
    func mapping(map: Map) {
        current <- map["page"]
        size <- map["pageSize"]
    }
    
    init(current: Int, size: Int) {
        self.current = current
        self.size = size
    }
}
