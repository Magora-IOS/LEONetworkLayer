import Foundation







extension UserProfile {
    
    init(dto: UserProfileDTO) {
        id = dto.id
        name = dto.name
        email = dto.email
        phone = dto.phone
        birthDate = dto.birthDate
    }
    
    
}


