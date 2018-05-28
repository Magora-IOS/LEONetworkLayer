import Foundation
import RxSwift






protocol MainViewModel {
    
    var tableSignal: PublishSubject<Void> { get }
    var rxTableSignal: PublishSubject<Void> { get }
}





class MainViewModelImpl: MainViewModel {
    
    typealias Context = Void
    
    
    
    //MARK: - Properties
    private let context: Context
    private let disposeBag = DisposeBag()
    
    let tableSignal = PublishSubject<Void>()
    let rxTableSignal = PublishSubject<Void>()
    
    
    
    
    
    
    
    //MARK: - Lifecycle
    init(context: Context) {
        self.context = context
        
        
    }
    
    
    
    //MARK: - Routines
    
    
    
    
}






