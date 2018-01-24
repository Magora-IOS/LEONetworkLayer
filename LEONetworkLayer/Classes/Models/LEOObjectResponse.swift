import ObjectMapper

open class LEOObjectResponse<T: BaseMappable>: LEOBaseResponse {
    
    public let data: T?
    
    required public init(map: Map) throws {
        data = try? map.value("data")
        
        try super.init(map: map)
    }
}
