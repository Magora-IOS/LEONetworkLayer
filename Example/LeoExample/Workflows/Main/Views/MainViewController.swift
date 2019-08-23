//
//  MainViewController.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var disposeBag = DisposeBag()
    
    var data: Driver<[News]> {
        return self.viewModel.items.asDriver(onErrorJustReturn: [])
    }
    
    // MARK: lifecycle    
    private let viewModel: NewsViewModel
    
    // MARK: lifecycle
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupRx()
    }
    
    private func setupViews() {
        self.title = L10n.News.title
        let cellNib = UINib(nibName: NewsCell.Identifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier:NewsCell.Identifier)
        
        self.loadingIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        //refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    func setupRx() {
        self.setupRxCellConfiguration()
        
        self.exitButton.rx.tap.bind{ [unowned self] _ in
            self.viewModel.exit()
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.state.subscribe(onNext: {
            [unowned self] state in
            
            //start
            if case .start = state {
                self.tableView.isHidden = true
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
                self.tableView.isHidden = false
            }
            
            //loading
            if case .loading = state {
            
            } else {
                self.tableView.refreshControl?.endRefreshing()
            }
            
            //error
            if case .dataError(let message) = state {
                self.errorLabel.text = message
            } else {
                self.errorLabel.text = ""
            }
            
        }).disposed(by: self.disposeBag)
        
    }
    
    private func setupRxCellConfiguration() {
        data.drive(self.tableView.rx.items(cellIdentifier: NewsCell.Identifier, cellType:NewsCell.self)) { _, viewModel, cell in
            cell.configureWithNews(viewModel)
            }.disposed(by: disposeBag)
    }
    
    @objc func refresh(sender:AnyObject)
    {
        self.viewModel.refresh()
    }
}
