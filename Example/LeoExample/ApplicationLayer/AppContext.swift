import Foundation
import LEONetworkLayer

protocol IAccountServiceContext {
    var accountService: IAccountService & ILeoTokenManager { get set}
}

protocol INewsServiceContext {
    var newsService: INewsService { get set}
}

typealias IAppContext =
    IAccountServiceContext & INewsServiceContext

open class AppContext: IAppContext {
    var accountService: IAccountService & ILeoTokenManager
    var accountStorage: IAccountStorage    
    var newsService: INewsService
    
    init() {
        self.accountStorage = AccountStorage(storage: KeychainStorage(prefix: String(describing: AccountStorage.self), icloud: false))
        self.accountService = AccountService(accountStorage: self.accountStorage)
        self.newsService = NewsService(tokenManager: self.accountService)
    }
}
