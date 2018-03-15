import RxSwift
import LEONetworkLayer


protocol ProfileService {
    
    func updateAvatar(resource: String) -> Single<Bool>
}



class ProfileServiceImpl: ProfileService, RxRequestService {
    
    
    private enum Error: ErrorObjectProvider {
        case method(String, Swift.Error)
        
        var object: Swift.Error {
            let result = ErrorObject(domain: "ProfileService")
            
            switch self {
            case let .method(name, error):
                result.desc = "\"\(name)\" action failed"
                result.underlyingError = error
            }
            return result
        }
    }
    
    
    
    //MARK: - Properties
    let apiProvider: LEOProvider
    
    
    
    //MARK: - Lifecycle
    init(apiProvider: LEOProvider) {
        self.apiProvider = apiProvider

    }

    
    
        //MARK: - Interface
    func updateAvatar(resource: String) -> Single<Bool> {
        let router = ProfileRouter.updateAvatar(resourceId: resource)
        return self.createObserver(type: LEOBaseResponse.self, router: router)
            .map {
                $0.isSuccess
            }
            .catchError {
                Observable.error(Error.method("Update avatar", $0).object)
            }
            .asSingle()
    }
}

