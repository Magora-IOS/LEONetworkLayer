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


protocol ResourcesServiceContext {
    var resourcesService: ResourcesService { get }
}


protocol CollectionServiceContext {
    var collectionService: CollectionService { get }
}




protocol AppContext: class,
    AuthStorageContext,
    AuthServiceContext,
    ProfileServiceContext,
    ResourcesServiceContext,
    CollectionServiceContext
    {}




class AppContextImpl: AppContext {
    
    let authStorage: AuthStorage
    let authService: AuthService
    let apiProvider: LEOProvider
    
    let resourcesService: ResourcesService
    let profileService: ProfileService
    let collectionService: CollectionService
    
    
    init() {
        self.authStorage = AuthStorageImpl(storage: KeychainStorage(prefix: "AuthStorage", icloud: false))
        
        self.apiProvider = LEOProvider(withConfiguration: URLSessionConfiguration.default)
        self.authService = AuthServiceImpl(apiProvider: self.apiProvider, authStorage: self.authStorage)
        self.apiProvider.authHandler = AuthorizationHandler(authService: self.authService)
        
        self.resourcesService = ResourcesServiceImpl(apiProvider: self.apiProvider, uploadProvider: UploadServiceImpl())
        self.profileService = ProfileServiceImpl(apiProvider: self.apiProvider)
        self.collectionService = CollectionServiceImpl(apiProvider: self.apiProvider)
    }
    
}
