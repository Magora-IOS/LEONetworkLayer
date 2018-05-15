import Foundation
import RxSwift





class SignInViewModel {
    
    typealias Context = AuthServiceContext
    
    
    //MARK: - Properties
    private let context: Context
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Lifecycle
    init(context: Context) {
        self.context = context
        
    }
    
    
    
    //MARK: - Routines
    func signIn(email: String, password: String) {
        self.context.authService.signIn(login: email, password: password)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
