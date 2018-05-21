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
    private var queryParams: CursorParameters!
    private var pageSize = 10

    
    let items = BehaviorRelay<[CollectionItem]>(value: [])
    let state = BehaviorRelay<TableViewModelState>(value: .empty)
    
    
    
   
    
    
    
    //MARK: - Lifecycle
    init(context: Context) {
        self.context = context
        
        self.queryParams = self.initialCursor()
    }
    
    
    
    //MARK: - Routines
    func reload() {
        self.queryParams = self.initialCursor()
        self.load()
    }
    
    
    func loadNextPage() {
        self.load()
    }
    
    
   
    private var loadDisposeBag: DisposeBag?
    private func load() {
        self.loadDisposeBag = DisposeBag()
     
        self.context.collectionService.items(self.queryParams)
            .do(onSubscribe: { [weak self] in
                self?.state.accept(.loading)
            })
            .subscribe(
                onSuccess: { [weak self] in
                    guard let strongSelf = self else { return }
                    let items = $0.0

                    if strongSelf.queryParams.cursor == nil {
                        strongSelf.items.accept(items)
                    } else {
                        let new = strongSelf.items.value + items
                        strongSelf.items.accept(new)
                    }
                    
                    if !items.isEmpty {
                        strongSelf.queryParams.cursor = $0.1.next
                    }
                    
                    strongSelf.state.accept(.done)
                },
                onError: { [weak self] in
                    self?.state.accept(.error($0))
                }
            )
            .disposed(by: self.loadDisposeBag!)
        
    }
    
    
    private func initialCursor() -> CursorParameters {
        return CursorParameters(cursor: nil, size: self.pageSize)
    }
}






