import Foundation
import ObjectMapper
import LEONetworkLayer



struct AuthSessionDTO: ImmutableMappable {
    
    var accessToken: String
    var accessTokenExpire: Date
    var refreshToken: String
    var authInfo: AuthInfoDTO

    
    init(map: Map) throws {
        accessToken = try map.value("accessToken")
        accessTokenExpire =  try map.value("accessTokenExpire", using: DateTransformISO8061())
        refreshToken = try map.value("refreshToken")
        authInfo = try map.value("authInfo")
    }
    
}




struct AuthInfoDTO: ImmutableMappable {
    
    var displayName: String
    var userId: String
    
    init(map: Map) throws {
        displayName = try map.value("displayName")
        userId = try map.value("userId")
    }
    
}
