//
//  WelcomeViewController.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import UIKit
import RxSwift

class WelcomeViewController: UIViewController {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    var onNext: (() -> ())?
    
    let disposeBag = DisposeBag()
    
    // MARK: lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    let userProvider = LeoProvider<AuthentificationTarget>()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userProvider.rx.request(.readUsers).subscribe { event in
            switch event {
            case let .success(response):
                if let returnData = String(data: response.data, encoding: .utf8) {
                print(returnData)
                }
                
                //let users = try! JSONDecoder().decode([User].self, from: response.data)
                //self.users = users
                
            case let .error(error):
                print(error)
            }
            }.disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        
      
        
    }
    
    private func setupViews() {
        self.title = ""
        
        self.nextButton.isEnabled = true
        self.nextButton.addTarget(self, action: #selector(nextButtonTap(_:)), for: .touchUpInside)
        
        self.errorLabel.text = ""
    }
    
    @objc func nextButtonTap(_ sender: UIButton) {
        onNext?()
    }
}
