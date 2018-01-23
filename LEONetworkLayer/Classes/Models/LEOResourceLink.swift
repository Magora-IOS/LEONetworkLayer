import ObjectMapper

class LEOResourceLink: ImmutableMappable {
    
    let resourceId: String
    let uploadUrl: String
    
    required init(map: Map) throws {
        resourceId = try map.value("resourceId")
        uploadUrl = try map.value("uploadUrl")
    }
    
    
}
