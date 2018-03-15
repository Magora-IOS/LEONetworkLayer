import Foundation
import RxSwift




enum ExampleViewModelState {
    case empty
    case loading
    case done
    case error(Error)
}



protocol ExampleViewModelInput {
    
    var newImageInput: PublishSubject<UIImage?> { get }
    var image: Variable<(MediaResource?, UIImage?)> { get }
    
    var dismissedNotification: PublishSubject<Void> { get }
}



protocol ExampleViewModelOutput {
    
   
}



protocol ExampleViewModel: ExampleViewModelInput, ExampleViewModelOutput {
    
    var state: Variable<ExampleViewModelState> { get }
}




class ExampleViewModelImpl: ExampleViewModel {
    
    typealias Context = ResourcesServiceContext & ProfileServiceContext
    
    
    
    //MARK: - Properties
    private let context: Context
    private let disposeBag = DisposeBag()
    
    let state = Variable<ExampleViewModelState>(.empty)

    
    
    //MARK: - Input
    let newImageInput = PublishSubject<UIImage?>()
    let image = Variable<(MediaResource?, UIImage?)>((nil, nil))
    
    let dismissedNotification = PublishSubject<Void>()
    
    
    //MARK: - Output
    
    
    
    //MARK: - Lifecycle
    init(context: Context) {
        self.context = context
        
        self.image.value = (nil, nil)
        
        self.newImageInput
            .filter { $0 != nil }
            .do(
                onNext: { [weak self] in
                    self?.updateImage($0!)
                }
            )
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    
    
    //MARK: - Routines
   
    
    
    private func updateImage(_ image: UIImage) {
        self.context.resourcesService.upload(image: image)
            .do(
                onSubscribe: { [weak self] in
                    self?.state.value = .loading
                }
            )
            .flatMap { [weak self] resourceId -> Single<Bool> in
                guard let strongSelf = self else {
                    return Single.error(CommonError.disposed.object)
                }
                return strongSelf.context.profileService.updateAvatar(resource: resourceId)
            }
            .subscribe(
                onNext: { [weak self] success in
                    if success {
                        self?.image.value = (nil, image)
                        self?.state.value = .done
                    } else {
                        self?.state.value = .error(CommonError.unknown.object)
                    }
                },
                onError: { [weak self] in
                    self?.state.value = .error($0)
                }
            )
            .disposed(by: self.disposeBag)
    }
}






