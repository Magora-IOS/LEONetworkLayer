import RxSwift
import LEONetworkLayer


protocol ProfileService {
   
}

class ProfileServiceImp: ProfileService, RxRequestService {
    let apiProvider: LEOProvider
    
    init(apiProvider: LEOProvider) {
        self.apiProvider = apiProvider

    }

}

