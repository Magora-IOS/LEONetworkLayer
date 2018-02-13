import ObjectMapper



open class LEOResourceLink: ImmutableMappable {

    public let resourceId: String
    public let uploadUrl: String
    
    
    public required init(map: Map) throws {
        resourceId = try map.value("resourceId")
        uploadUrl = try map.value("uploadUrl")
    }
    
    
}
