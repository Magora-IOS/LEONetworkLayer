import Foundation
import LEONetworkLayer


protocol AuthStorageContext {
    var authStorage: AuthStorage { get }
}


protocol AuthServiceContext {
    var authService: AuthService { get }
}


protocol ProfileServiceContext {
    var profileService: ProfileService { get }
}





protocol AppContext: class,
    AuthStorageContext,
    AuthServiceContext,
    ProfileServiceContext
    {}




class AppContextImpl: AppContext {
    
    let authStorage: AuthStorage
    let authService: AuthService
    let apiProvider: LEOProvider
    
    let profileService: ProfileService

    
    init() {
        self.authStorage = AuthStorageImpl(storage: KeychainStorage(prefix: "AuthStorage", icloud: false))
        
        self.apiProvider = LEOProvider(withConfiguration: URLSessionConfiguration.default)
        self.authService = AuthServiceImpl(apiProvider: self.apiProvider, authStorage: self.authStorage)
        self.apiProvider.authHandler = AuthorizationHandler(authService: self.authService)
        
        self.profileService = ProfileServiceImpl(apiProvider: self.apiProvider)
       
    }
    
}
