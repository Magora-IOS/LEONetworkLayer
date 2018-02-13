import ObjectMapper

open class LEOListResponse<T: BaseMappable>: LEOBaseResponse {
    
    public let data: [T]
    
    //TODO: clear this - is it optional or required?
    public let nextCursor: String?
    public let prevCursor: String?
    
    
    required public init(map: Map) throws {
        data = try map.value("data.items")
        nextCursor = try? map.value("data.nextCursor")
        prevCursor = try? map.value("data.prevCursor")
        
        try super.init(map: map)
    }
    
}
