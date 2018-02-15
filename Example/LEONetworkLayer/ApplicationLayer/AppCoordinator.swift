import UIKit
import RxSwift



class AppCoordinator: BaseCoordinator {
    
    
    //MARK: - Properties
    private let window: UIWindow
    private let context: AppContext
    private var rootViewController: UINavigationController? {
        return self.window.rootViewController as? UINavigationController
    }
    
    private let disposeBag = DisposeBag()
    
    
    
    //MARK: - Lifecycle
    init(window: UIWindow, context: AppContext) {
        self.window = window
        self.context = context
    }
    
    
    
    //MARK: - Flows
    override func start() {
        self.context.authService
            .authorised.asObservable()
            .subscribe(onNext: { [weak self] auth in
                Log("Authorization changed to: \(auth)")
                self?.chooseFlow(auth: auth)
            })
            .disposed(by: self.disposeBag)
    }
    
    
    //MARK: - Flows (Private)
    private func chooseFlow(auth: Bool) {
        if auth {
            self.startMain()
        } else {
            self.startLogin()
        }
    }
    
    
    
    private func startLogin() {
        let nvc = UINavigationController()
        self.window.changeRootViewController(nvc)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
        nvc.pushViewController(vc, animated: true)
    }
    
    
    
    private func startMain() {
        let nvc = UINavigationController()
        self.window.changeRootViewController(nvc)
     
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
        nvc.pushViewController(vc, animated: true)
    }
    
    

}
