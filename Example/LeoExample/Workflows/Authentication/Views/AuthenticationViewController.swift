//
//  WelcomeViewController.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import LEONetworkLayer


class AuthenticationViewController: UIViewController {
    
    @IBOutlet var messageLabel: UILabel!    
    @IBOutlet var numberField: UITextField!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    private let viewModel: AuthenticationViewModel
    
    // MARK: lifecycle
    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    let userProvider = LeoProviderFactory<UserTarget>().makeProvider(tokenManager: nil)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupRx()
    }
    
    private func setupViews() {
        self.title = ""
        self.loadingIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)                
        self.nextButton.isEnabled = true
    }
    
    private func setupRx() {
        self.viewModel.message
            .bind(to: self.messageLabel.rx.text)
            .disposed(by: self.disposeBag)
        
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
            
        }).disposed(by: self.disposeBag)
        
        if case .welcome = self.viewModel.state.value {
            self.nextButton.rx.tap
                .bind(to: self.viewModel.onSendPhoneEvent)
                .disposed(by: self.disposeBag)
        }
        
        if case .confirmation = self.viewModel.state.value {
            self.nextButton.rx.tap
                .bind(to: self.viewModel.onSendPinEvent)
                .disposed(by: self.disposeBag)
        }
        
        self.numberField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(self.numberField.rx.text)
            .map({[unowned self] text in
                let result = text?.left(10) ?? ""
                self.numberField.text = result
                return result
            })
            .bind(to: viewModel.number)
            .disposed(by: self.disposeBag)                        
    }
}
