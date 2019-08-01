import Foundation
import LEONetworkLayer

protocol IAccountServiceContext {
    var accountService: IAccountService & ILeoTokenManager { get set}
}

typealias IAppContext =
    IAccountServiceContext

open class AppContext: IAppContext {
    var accountService: IAccountService & ILeoTokenManager
    var accountStorage: IAccountStorage
    var userService: IUserService
    var newsService: INewsService
    
    init() {
        self.accountStorage = AccountStorage(storage: KeychainStorage(prefix: String(describing: AccountStorage.self), icloud: false))
        self.accountService = AccountService(accountStorage: self.accountStorage)
        self.userService = UserService(tokenManager: self.accountService)
        self.newsService = NewsService(tokenManager: self.accountService)
    }
}
