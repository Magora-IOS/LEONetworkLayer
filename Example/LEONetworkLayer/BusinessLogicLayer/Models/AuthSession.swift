import Foundation




struct AuthSession {
    
    var accessToken: String?
    var accessTokenExpire: Date?
    var refreshToken: String?
    var authInfo: AuthInfo?
    
    init() {
        
    }
}




struct AuthInfo {
    
    var displayName: String?
    var userId: String?
    
    init() {
        
    }
}

