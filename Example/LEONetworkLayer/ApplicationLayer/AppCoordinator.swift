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
        self.window.changeRootViewController(UINavigationController())
        
        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        vc.viewModel = SignInViewModel(context: self.context)
        self.rootViewController?.pushViewController(vc, animated: true)
    }
    
    
    
    private func startMain() {
        self.window.changeRootViewController(UINavigationController())
     
        let vm = MainViewModelImpl(context: ())
        
        vm.tableSignal.subscribe(onNext: { [weak self] in
            self?.startTable()
        })
        .disposed(by: self.disposeBag)
        
        vm.rxTableSignal.subscribe(onNext: { [weak self] in
            self?.startRxTable()
        })
            .disposed(by: self.disposeBag)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.viewModel = vm
        
        self.rootViewController?.pushViewController(vc, animated: true)
    }
    
    
    

    //MARK: - Flows (2nd Level)
    private func startTable() {
        let vc = UIStoryboard(name: "Table", bundle: nil).instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        vc.viewModel = TableViewModelImpl(context: self.context)
        self.rootViewController?.pushViewController(vc, animated: true)
    }
    
    private func startRxTable() {
        let vc = UIStoryboard(name: "RxTable", bundle: nil).instantiateViewController(withIdentifier: "RxTableViewController") as! RxTableViewController
        vc.viewModel = TableViewModelImpl(context: self.context)
        self.rootViewController?.pushViewController(vc, animated: true)
    }
}
