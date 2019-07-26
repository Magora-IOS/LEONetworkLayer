//
//  AuthenticationCoordinator.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import BaseCoordinator

class AuthenticationCoordinator: BaseCoordinator {
    let router: UINavigationController
    var context: AppContext
    
    init(router: UINavigationController, context: AppContext) {
        self.router = router
        self.context = context
    }
    
    override func start() {
        if !self.context.accountService.isAuthenticated {
            startWelcome()
        } else {
            self.completionHandler?()
        }
    }
    
    // MARK: Starting modules
    private func startWelcome() {
        let viewController = WelcomeViewController()
        viewController.onNext = { [weak self] in
            self?.context.accountService.login()
            self?.completionHandler?()
        }
        router.pushViewController(viewController, animated: true)
    }
}
