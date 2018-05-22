import UIKit



class MainViewController: UITableViewController {

    
    //MARK: - Outlets
    @IBOutlet weak var tableCell: UITableViewCell!
    @IBOutlet weak var rxTableCell: UITableViewCell!
    
    
    //MARK: - Properties
    var viewModel: MainViewModel!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        

        
    }



    
    //MARK: - Table
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        switch cell {
        case self.tableCell:
            self.viewModel.tableSignal.onNext(())
          
        case self.rxTableCell:
            self.viewModel.rxTableSignal.onNext(())
        
        default:
            return
        }
    }
}

