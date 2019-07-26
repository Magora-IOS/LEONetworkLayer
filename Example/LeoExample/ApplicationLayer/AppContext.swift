import Foundation

protocol AccountServiceContext {
    var accountService: AccountService { get set}
}

typealias AppContext =
    AccountServiceContext

open class AppContextImpl: AppContext {
    var accountService: AccountService
    
    init() {
        self.accountService = AccountServiceImpl()
    }
}
