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
    
    func reload()
    func loadNextPage()
    
    var items: BehaviorRelay<[CollectionItem]> { get }
    var state: BehaviorRelay<TableViewModelState> { get }
}




class TableViewModelImpl: TableViewModel {
    
    typealias Context = CollectionServiceContext
    
    
    
    //MARK: - Properties
    private let context: Context
    private let disposeBag = DisposeBag()
    
    let items = BehaviorRelay<[CollectionItem]>(value: [])
    let state = BehaviorRelay<TableViewModelState>(value: .empty)
    
    
    
   
    
    
    
    //MARK: - Lifecycle
    init(context: Context) {
        self.context = context
        
        
    }
    
    
    
    //MARK: - Routines
    func reload() {
        
    }
    
    
    func loadNextPage() {
        
    }
    
    
   
}






