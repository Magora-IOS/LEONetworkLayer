import RxSwift
import LEONetworkLayer


protocol ProfileService {
   
}

class ProfileServiceImp: ProfileService, RxRequestService {
    let apiProvider: RestProvider
    
    init(apiProvider: RestProvider) {
        self.apiProvider = apiProvider

    }

}

