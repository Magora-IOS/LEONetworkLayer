import UIKit
import RxSwift
import LEONetworkLayer



enum ResourceContentType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
}



protocol ResourcesService {
    
    func generateUploadLink(contentType: ResourceContentType) -> Observable<LEOMediaResourceUploadLink>
    func upload(image: UIImage) -> Observable<String>
}



class ResourcesServiceImpl: RxRequestService, ResourcesService {
    
    
    
    private enum Error: ErrorObjectProvider {
        case method(String, Swift.Error)
        case badMediaResource
        case urlInvalid
        case disposed
        
        
        var object: Swift.Error {
            let result = ErrorObject(domain: "ResourceService")
            
            switch self {
            case let .method(name, error):
                result.desc = L10n.Common.Apimethodfailed.format(name)
                result.underlyingError = error
                
            case .badMediaResource:
                result.desc = "Cant convert to Data"
                
            case .urlInvalid:
                result.desc = "Backend returned invalid URL to upload"
                
            case .disposed:
                result.underlyingError = CommonError.disposed.object
            }
            return result
        }
    }
    
    
    //MARK: - Properties
    let apiProvider: LEOProvider
    private let uploadService: UploadService
    
    
    //MARK: - Lifecycle
    init(apiProvider: LEOProvider, uploadProvider: UploadService) {
        self.apiProvider = apiProvider
        self.uploadService = uploadProvider
    }
    
    
    
    //MARK: - Requests
    func generateUploadLink(contentType: ResourceContentType) -> Observable<LEOMediaResourceUploadLink> {
        let router = ResourceRouter.generateUploadImageLink(contentType: contentType.rawValue)
        return self.createObserver(type: LEOObjectResponse<LEOMediaResourceUploadLink>.self, router: router)
            .map {
                $0.data
            }
            .catchError {
                Observable.error(Error.method("Generate upload link", $0).object)
            }
    }
    
    
    func upload(image: UIImage) -> Observable<String> {
        let contentType = ResourceContentType.jpeg
        return self.convertImageToData(image, contentType: contentType)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .flatMap { [weak self] in
                return self?.createMediaResource(data: $0, contentType: contentType) ?? Observable.error(CommonError.disposed.object)
            }
    }
    

    
    
    
    //MARK: - Routines
    private func convertVideoToData(_ videoURL: URL) -> Observable<Data> {
        return Observable<Data>.create ({ observer -> Disposable in
            if let data = try? Data(contentsOf: videoURL) {
                observer.onNext(data)
                observer.onCompleted()
            } else {
                observer.onError(Error.badMediaResource.object)
            }
            return Disposables.create { }
        })
    }
    
    
    private func convertImageToData(_ image: UIImage, contentType: ResourceContentType) -> Observable<Data> {
        return Observable<Data>.create ({ observer -> Disposable in
            var data: Data? = nil
            
            switch contentType {
            case .jpeg:
                data = UIImageJPEGRepresentation(image, 0.9)
                
            case .png:
                data = UIImagePNGRepresentation(image)
                
            //default:
            //    Log("\(contentType) not supported")
            }
            
            let disposable = Disposables.create { }
            
            guard data != nil else {
                observer.onError(Error.badMediaResource.object)
                return disposable
            }
            
            observer.onNext(data!)
            observer.onCompleted()
        
            return disposable
        })
    }
    
    
    private func createMediaResource(data: Data, contentType: ResourceContentType) -> Observable<String> {
        return self.generateUploadLink(contentType: contentType)
            .map { link -> (resourceId: String, uploadUrl: URL) in
                guard let url = URL(string: link.uploadUrl) else {
                    throw Error.urlInvalid.object
                }
                return (link.resourceId, url)
            }
            .flatMap { [weak self] (resource) -> Observable<String> in
                guard let strongSelf = self else {
                    throw Error.disposed.object
                }
                
                return strongSelf.uploadMedia(data, uploadUrl: resource.uploadUrl, contentType: contentType)
                    .flatMap { (url) -> Observable<String> in
                        return Observable.just(resource.resourceId)
                    }
            }
    }

    
    private func uploadMedia(_ data: Data, uploadUrl: URL, contentType: ResourceContentType) -> Observable<Void> {
        return self.uploadService.upload(data: data, contentType: contentType.rawValue, url: uploadUrl)
    }
 
}

