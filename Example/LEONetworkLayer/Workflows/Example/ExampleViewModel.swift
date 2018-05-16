import Foundation
import RxSwift
import RxCocoa



enum ExampleViewModelState {
    case empty
    case loading
    case done
    case error(Error)
}



protocol ExampleViewModelInput {
    
    var newImageInput: PublishSubject<UIImage?> { get }
    var image: BehaviorRelay<(MediaResource?, UIImage?)> { get }
    
    var dismissedNotification: PublishSubject<Void> { get }
}



protocol ExampleViewModelOutput {
    
   
}



protocol ExampleViewModel: ExampleViewModelInput, ExampleViewModelOutput {
    
    var state: BehaviorRelay<ExampleViewModelState> { get }
}




class ExampleViewModelImpl: ExampleViewModel {
    
    typealias Context = ResourcesServiceContext & ProfileServiceContext
    
    
    
    //MARK: - Properties
    private let context: Context
    private let disposeBag = DisposeBag()
    
    let state = BehaviorRelay<ExampleViewModelState>(value: .empty)

    
    
    //MARK: - Input
    let newImageInput = PublishSubject<UIImage?>()
    let image = BehaviorRelay<(MediaResource?, UIImage?)>(value: (nil, nil))
    
    let dismissedNotification = PublishSubject<Void>()
    
    
    //MARK: - Output
    
    
    
    //MARK: - Lifecycle
    init(context: Context) {
        self.context = context
        
        self.image.accept((nil, nil))
        
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
                    self?.state.accept(.loading)
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
                        self?.image.accept((nil, image))
                        self?.state.accept(.done)
                    } else {
                        self?.state.accept(.error(CommonError.unknown.object))
                    }
                },
                onError: { [weak self] in
                    self?.state.accept(.error($0))
                }
            )
            .disposed(by: self.disposeBag)
    }
}






