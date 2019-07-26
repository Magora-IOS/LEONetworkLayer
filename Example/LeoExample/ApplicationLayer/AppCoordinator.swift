import Foundation
import UIKit
import BaseCoordinator

class AppCoordinator: BaseCoordinator {
    let window: UIWindow
    var context: AppContext
    var mainFlowStarted: (()->())?
    
    private var mainCoordinator: MainCoordinator?
    private var authenticationCoordinator: AuthenticationCoordinator?
    
    init(window: UIWindow, context: AppContext) {
        self.window = window
        self.context = context
    }
    
    override func start() {
        context.accountService.logoutHandler = { [weak self] in
            guard let `self` = self else { return }
            self.mainCoordinator = nil
            self.authenticationCoordinator = nil
            for childCoordinator in self.childCoordinators {
                self.removeDependency(childCoordinator)
            }
            self.startAuthentication()
        }
        chooseFlow()
    }
    
    func chooseFlow() {
        if self.context.accountService.isAuthenticated {
            self.startMain()
        } else {
            self.startAuthentication()
        }
    }
    
    func startAuthentication() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        mainCoordinator = nil
        authenticationCoordinator = AuthenticationCoordinator(router: navigationController, context: context)
        authenticationCoordinator!.start()
        authenticationCoordinator!.completionHandler = { [weak self] in
            self?.removeDependency(self?.authenticationCoordinator)
            self?.authenticationCoordinator = nil
            self?.chooseFlow()
        }
        self.addDependency(authenticationCoordinator!)
    }
    
    func startMain() {
        let mainNavigationController = UINavigationController()
        window.rootViewController = mainNavigationController
        
        let coordinator = MainCoordinator(router: mainNavigationController, context: context)
        self.mainCoordinator = coordinator
        self.addDependency(coordinator)
        coordinator.start()
    }
}
