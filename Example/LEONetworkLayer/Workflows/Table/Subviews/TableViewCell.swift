import UIKit



class TableViewCell: UITableViewCell {

    //MARK: - Properties
    var data: (CollectionItem, Int)? {
        didSet {
            self.updateView()
        }
    }
    
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateView()
    }

    
    
    //MARK: - Routines
    private func updateView() {
        guard let data = self.data else {
            self.textLabel?.text = nil
            return
        }
        
        let repeats = data.1 % 10 + 1
        var title = (1...repeats).reduce("", { (result, _) in
            result + data.0.title + "\n"
        })
        title.removeLast()
        
        self.textLabel?.text = title
    }

}
