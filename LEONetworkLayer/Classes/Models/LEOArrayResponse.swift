import ObjectMapper

class LEOArrayResponse<T: BaseMappable>: LEOBaseResponse {
    
    let data: [T]?
    
    required init(map: Map) throws {
        data = try? map.value("data")
        
        try super.init(map: map)
    }
}
