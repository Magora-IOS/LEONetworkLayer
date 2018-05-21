import ObjectMapper
import LEONetworkLayer



struct CollectionItemDTO: ImmutableMappable {
    
    var id: String
    var number: Int
    var title: String
    var deleted: Bool
    var created: Date
    var blocked: Bool
    
    
    init(map: Map) throws {
        id = try map.value("id")
        number = try map.value("number")
        title = try map.value("title")
        deleted = try map.value("deleted")
        created = try map.value("createdAt", using: DateTransformISO8601())
        blocked = try map.value("blocked")
    }
    
}



