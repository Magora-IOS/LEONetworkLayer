import ObjectMapper

class LEOImageResource: ImmutableMappable {
    
    let resourceId: String
    
    let formatUrls360: URL?
    let formatUrls480: URL?
    let formatUrls720: URL?
    let formatUrls1080: URL?
    
    let contentType: String?
    
    
    required init(map: Map) throws {
        resourceId = try map.value("resourceId")
        contentType = try? map.value("contentType")
        
        formatUrls360 = try? map.value("formatUrls.360", using: URLTransform())
        formatUrls480 = try? map.value("formatUrls.480", using: URLTransform())
        formatUrls720 = try? map.value("formatUrls.720", using: URLTransform())
        formatUrls1080 = try? map.value("formatUrls.1080", using: URLTransform())
    }
}
