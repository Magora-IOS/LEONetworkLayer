import Foundation
import RxSwift
import RxCocoa



enum TableViewModelState {
    case empty
    case loading
    case done
    case error(Error)
}







protocol TableViewModel {
    
    var state: BehaviorRelay<TableViewModelState> { get }
}




class TableViewModelImpl: TableViewModel {
    
    typealias Context = ResourcesServiceContext & ProfileServiceContext
    
    
    
    //MARK: - Properties
    private let context: Context
    private let disposeBag = DisposeBag()
    
    let state = BehaviorRelay<TableViewModelState>(value: .empty)
    
    
    
   
    
    
    
    //MARK: - Lifecycle
    init(context: Context) {
        self.context = context
        
        
    }
    
    
    
    //MARK: - Routines
    
    
    
   
}






