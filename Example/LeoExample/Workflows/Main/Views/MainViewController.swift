//
//  MainViewController.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    var onExit: (() -> ())?
    
    // MARK: lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        onExit?()
    }
}
