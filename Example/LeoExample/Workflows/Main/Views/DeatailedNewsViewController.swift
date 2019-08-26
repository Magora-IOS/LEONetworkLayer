//
//  OneNewsViewController.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class DetailedNewsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    // MARK: lifecycle
    private let viewModel: DetailedNewsViewModel

    // MARK: lifecycle
    init(viewModel: DetailedNewsViewModel) {
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
        self.title = L10n.DetailedNews.title
        self.loadingIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    func setupRx() {
        self.viewModel.state.subscribe(onNext: {
            [unowned self] state in
            
            //loading
            if case .loading = state {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
            
            //error
            if case .dataError(let message) = state {                
                self.errorLabel.text = message
            } else {
                self.errorLabel.text = ""
            }
            
            //finished
            if case .finished(let news) = state {
                self.titleLabel.text = news.title
                self.dateLabel.text = news.createDate?.dateTimeNewsFormat
                self.descriptionLabel.attributedText = news.description?.htmlCentered()
            } else {
                self.titleLabel.text = nil
                self.dateLabel.text = nil
                self.descriptionLabel.text = nil
            }
            
            
        }).disposed(by: self.disposeBag)
        
        self.refreshButton.rx.tap.bind{ [unowned self] _ in
            self.viewModel.refresh()
            }
            .disposed(by: self.disposeBag)
    }
    
   
}
