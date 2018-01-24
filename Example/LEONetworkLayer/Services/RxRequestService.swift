import RxSwift
import LEONetworkLayer


protocol RxRequestService {
    var apiProvider: RestProvider {get}
}

extension RxRequestService {
    
    func createObserver<T: LEOBaseResponse>(type: T.Type, router: RestRouter) -> Observable<T>{
        return Observable<T>.create ({ observer -> Disposable in
            let request = self.apiProvider.request(router: router) { (response: Response<T>) in
                switch response {
                case let .Success(result):
                    observer.onNext(result)
                    observer.onCompleted()
                    break
                case let .Error(error):
                    observer.onError(error)
                    break
                }
            }
            return Disposables.create {
                request.cancel()
            }
        })
    }
}
