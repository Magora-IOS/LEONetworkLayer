import UIKit
import RxSwift
import RxCocoa
import UIScrollView_InfiniteScroll



class RxTableViewController: UIViewController {
    
    
    
    //MARK: - Properties
    var viewModel: TableViewModel!
    var disposeBag = DisposeBag()
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    private var emptyView: EmptyTableView!
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buildViews()
        self.binding()
        self.refreshControl.beginRefreshingManually(animated: false)
    }
    
    
    private func buildViews() {
        self.refreshControl = UIRefreshControl()
        self.tableView.insertSubview(self.refreshControl, at: 0)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView.infiniteScrollTriggerOffset = 700
        
        self.emptyView = EmptyTableView.loadFromNib()!
        self.tableView.backgroundView = self.emptyView
    }
    
    
    private func binding() {
        self.tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.nameOfClass)
      
        self.viewModel.items.asObservable()
            .bind(to: self.tableView.rx.items(cellIdentifier: TableViewCell.nameOfClass,
                                              cellType: TableViewCell.self)) { (row, data, cell) in
                                                cell.data = (data, row)
            }.disposed(by: self.disposeBag)
        
        self.tableView.addInfiniteScroll { [weak self] _ in
            self?.viewModel.loadNextPage()
        }
        
        self.tableView.setShouldShowInfiniteScrollHandler { [weak self] _ in
            guard let strongSelf = self else { return false }
            if case .empty = strongSelf.viewModel.state.value {
                return false
            } else {
                return strongSelf.viewModel.isMoreItems()
            }
        }
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.reload()
            })
            .disposed(by: self.disposeBag)
        
        
        self.viewModel.state.asObservable()
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .initial:
                    self?.emptyView.isHidden = true
                    
                case .loading:
                    self?.emptyView.isHidden = true
                    
                case .empty:
                    self?.emptyView.isHidden = false
                    self?.refreshControl.endRefreshing()
                    self?.tableView.finishInfiniteScroll()
                    
                case .done:
                    self?.emptyView.isHidden = true
                    self?.refreshControl.endRefreshing()
                    self?.tableView.finishInfiniteScroll()
                    
                case let .error(e):
                    self?.emptyView.isHidden = true
                    self?.refreshControl.endRefreshing()
                    self?.tableView.finishInfiniteScroll()
                    ErrorAlert(error: e, presenter: self)
                }
            })
            .disposed(by: self.disposeBag)
    }
}
