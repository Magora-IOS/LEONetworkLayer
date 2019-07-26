//
//  MainCoordinator.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import BaseCoordinator

class MainCoordinator: BaseCoordinator {
    typealias Router = UINavigationController
    
    private var router: Router
    private let context: AppContext
    
    override func start() {
        let viewController = MainViewController()
        viewController.onExit = { [weak self] in
            self?.context.accountService.signOut()            
        }
        router.pushViewController(viewController, animated: true)
    }
    
    init(router: Router, context: AppContext) {
        self.router = router
        self.context = context
        super.init()
    }
    
}

