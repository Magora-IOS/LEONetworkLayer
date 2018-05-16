import Foundation







extension CollectionItem {
    
    init(dto: CollectionItemDTO) {
        id = dto.id
        number = dto.number
        title = dto.title
        deleted = dto.deleted
        created = dto.created
        blocked = dto.blocked
    }
    
    
}


