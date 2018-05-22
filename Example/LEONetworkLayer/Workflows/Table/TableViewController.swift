import UIKit
import RxSwift
import RxCocoa
import UIScrollView_InfiniteScroll



class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
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
        self.viewModel.reload()
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
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.viewModel.items
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
                self?.tableView.finishInfiniteScroll()
            })
            .disposed(by: self.disposeBag)
        
        
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
    
    
    
    
    //MARK: - Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items.value.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.nameOfClass, for: indexPath) as! TableViewCell
        
        let item = self.viewModel.items.value[indexPath.row]
        
        let repeats = indexPath.row % 10 + 1
        var title = (1...repeats).reduce("", { (result, _) in
            result + item.title + "\n"
        })
        title.removeLast()
        
        cell.textLabel?.text = title
        return cell
    }
}
