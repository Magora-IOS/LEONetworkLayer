import RxSwift
import LEONetworkLayer





protocol RxRequestService {
    var apiProvider: LEOProvider { get }
}


extension RxRequestService {
    
    func createObserver<T: LEOBaseResponse>(type: T.Type, router: LEORouter) -> Observable<T>{
        return Observable<T>.create { observer -> Disposable in
            let request = self.apiProvider.request(router: router) { (response: Response<T>) in
                switch response {
                    
                case let .success(result):
                    observer.onNext(result)
                    observer.onCompleted()
                    
                case let .error(error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

