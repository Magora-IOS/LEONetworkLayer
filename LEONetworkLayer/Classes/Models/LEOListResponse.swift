import ObjectMapper

class LEOListResponse<T: BaseMappable>: LEOBaseResponse {
    
    let data: [T]?
    
    //TODO: clear this - is it optional or required?
    let nextCursor: String?
    let prevCursor: String?
    
    
    required init(map: Map) throws {
        data = try? map.value("data")
        nextCursor = try? map.value("data.nextCursor")
        prevCursor = try? map.value("data.prevCursor")
        
        try super.init(map: map)
    }
    
}
