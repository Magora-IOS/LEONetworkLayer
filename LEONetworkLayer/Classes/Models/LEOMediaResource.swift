import ObjectMapper


open class LEOMediaResource: ImmutableMappable {
    
    public let id: String
    public let originalUrl: URL
    public let contentType: String?
    
    
    public let formatUrls: [String: String]?
    
    
    public required init(map: Map) throws {
        id = try map.value("id")
        contentType = try map.valueOrNil("contentType")
        originalUrl = try map.value("originalUrl", using: URLTransform())
        formatUrls = try map.value("formatUrls")
    }
}
