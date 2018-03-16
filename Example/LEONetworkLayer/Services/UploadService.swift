import RxSwift
import Alamofire




protocol UploadService {
   
    func upload(data: Data, contentType: String, url: URL) -> Observable<Progress>
    func upload(file: URL, contentType: String, url: URL) -> Observable<Progress>
}




class UploadServiceImpl: UploadService {
    
    
    
    
    private enum Error: ErrorObjectProvider {
        case wrongHttpStatus

        
        var object: Swift.Error {
            let result = ErrorObject(domain: "UploadService")
            
            switch self {
            case .wrongHttpStatus:
                break;
            }
            return result
        }
    }
    
    
    
    
    //MARK: - Properties
    private let sessionManager: SessionManager

    
    //MARK: - Lifecycle
    init(withConfiguration configuration: URLSessionConfiguration) {
        self.sessionManager = SessionManager(configuration: configuration)
    }
    
    
    
    //MARK: - Interface
    func upload(data: Data, contentType: String, url: URL) -> Observable<Progress> {
        
        return Observable<Progress>.create { observer -> Disposable in
            let request = self.sessionManager.upload(data, to: url, method: .put, headers: ["Content-Type": contentType])
                .uploadProgress {
                    observer.onNext($0)
                }
                .response(completionHandler: {
                    guard let code = $0.response?.statusCode, code == 200 else {
                        observer.onError(Error.wrongHttpStatus.object)
                        return
                    }
                    
                    observer.onCompleted()
                })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    
    
    func upload(file: URL, contentType: String, url: URL) -> Observable<Progress> {
        
        return Observable<Progress>.create { observer -> Disposable in
            let request = self.sessionManager.upload(file, to: url, method: .put, headers: ["Content-Type": contentType])
                .uploadProgress {
                    observer.onNext($0)
                }
                .response(completionHandler: {
                    guard let code = $0.response?.statusCode, code == 200 else {
                        observer.onError(Error.wrongHttpStatus.object)
                        return
                    }
                    
                    observer.onCompleted()
                })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
