import RxSwift
import LEONetworkLayer


protocol ProfileService {
   
}


class ProfileServiceImpl: ProfileService, RxRequestService {
    
    //MARK: - Properties
    let apiProvider: LEOProvider
    
    
    //MARK: - Lifecycle
    init(apiProvider: LEOProvider) {
        self.apiProvider = apiProvider

    }

}

