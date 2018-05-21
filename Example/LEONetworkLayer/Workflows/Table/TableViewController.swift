import UIKit
import RxSwift
import RxCocoa



class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    //MARK: - Properties
    var viewModel: TableViewModel!
    var disposeBag = DisposeBag()
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.binding()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.reload()
    }
    
    
    
    private func binding() {
        self.tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.nameOfClass)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.viewModel.items
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
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
        cell.textLabel?.text = item.title
        
        return cell
    }
}
