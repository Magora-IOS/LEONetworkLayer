//
//  AccountService.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import LEONetworkLayer

protocol IAccountService {
    var isAuthenticated: Bool { get }
    var logoutHandler: (() -> Void)? { get set }
    
    func sendPhone(phone: String) -> Single<Response>
    //func signin(phone: String, code: String) -> Single<SignInResponse>
    
    func login()
    func signOut()
    var accountProvider: LeoProvider<AuthentificationTarget> {get}
}

class AccountService: IAccountService {
    private(set) var accountStorage: IAccountStorage
    lazy public var accountProvider = LeoProvider<AuthentificationTarget>(tokenManager: self, mockType: .none, plugins: [TestPlugin()])
    
    private let loginKey = "login"
    
    var isAuthenticated: Bool {
        return accountStorage.accessToken != nil
    }
    
    func sendPhone(phone: String) -> Single<Response> {
        return accountProvider.rx
            .request(.sendPhone(phone: phone))
    }
    
    func login() {
        accountStorage.accessToken = "test"
    }
    
    var logoutHandler: (() -> Void)?
    
    func signOut() {
        invalidateTokens()
        logoutHandler?()
    }
    
    func invalidateTokens() {
        self.invalidateRefreshToken()
        self.invalidateAccessToken()
    }
    
    func invalidateAccessToken() {
        self.accountStorage.accessToken = nil
    }
    
    func invalidateRefreshToken() {
        self.accountStorage.refreshToken = nil
    }
    
    
    init(accountStorage: IAccountStorage) {
        self.accountStorage = accountStorage
    }
}


extension AccountService: ILeoTokenManager {
    
    var refreshTokenTimeout: TimeInterval {
        return 12.0
    }
    
    func getAccessToken() -> String {
        return accountStorage.accessToken ?? ""
    }
    
    func getRefreshToken() -> String {
        return accountStorage.refreshToken ?? ""
    }
    
    func refreshToken() -> Single<Response>? {
        if let token = accountStorage.refreshToken {
            return accountProvider.rx.request(.refreshToken(refreshToken: token ))
        } else {
            return nil
        }
    }
    
    func clearTokensAndHandleLogout() {
        signOut()
    }
}
