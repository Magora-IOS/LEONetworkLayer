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
    var isRegistered: Bool { get }
    
    var logoutHandler: (() -> Void)? { get set }
    
    func sendPhone(phone: String) -> Single<AccountStatus>
    func signIn(phone: String, code: String) -> Single<SignInResponse>
    func registerUser(userData: UserRegistrationInfoDTO) -> Single<Void>
    
    func signOut()
    func setRegistration(passed: Bool)
}

class AccountService: IAccountService {
    private(set) var accountStorage: IAccountStorage
    
    lazy private var accountProvider = LeoProviderFactory<AuthentificationTarget>().makeProvider(tokenManager: self)
    lazy private var mockAccountProvider = LeoProviderFactory<AuthentificationTarget>().makeProvider(mockType: .delayed(seconds: 0.5))
    
    func requestMap<T:Codable>(_ input: T.Type, target: AuthentificationTarget, mock: Bool = false) -> Single<T> {
        let provider = mock ? mockAccountProvider : accountProvider
        return provider.rx.request(target).map(T.self).catchError({ error in
            let serviceError = AccountServiceError.convertError(error)
            return Single.error(serviceError)
        })
    }
    
    var isAuthenticated: Bool {        
        return accountStorage.accessToken != nil
    }
    
    var isRegistered: Bool {
        return accountStorage.registered
    }
    
    func sendPhone(phone: String) -> Single<AccountStatus> {
        return requestMap(AccountStatus.self, target: .sendPhone(phone: phone))
    }
    
    func signIn(phone: String, code: String) -> Single<SignInResponse> {
        let request = TokenRequestParameters()
        request.phone = phone
        request.code = code
        request.meta.deviceID = self.accountStorage.deviceID
        
        return accountProvider.rx.request(.login(login: request)).flatMap({
            response in
            if let tokens = try? response.map(TokenResponse.self) {
                self.accountStorage.accessToken = tokens.accessToken
                self.accountStorage.refreshToken = tokens.refreshToken
            } else {
                throw AccountServiceError.noTokenError
            }
            
            if let signInResponse = try? response.map(SignInResponse.self) {
                self.accountStorage.userID = signInResponse.authInfo.userId
                return .just(signInResponse)
            } else {
                throw AccountServiceError.noAuthDataError
            }
        }).catchError({ error in
            let serviceError = AccountServiceError.convertError(error)
            return Single.error(serviceError)
        })
    }
    
    func registerUser(userData: UserRegistrationInfoDTO) -> Single<Void> {
        //mock for register request
        return mockAccountProvider.rx
            .request(.register(data: userData)).flatMap({
                response in
                    return .just(())
            }).catchError({ error in
                let serviceError = AccountServiceError.convertError(error)
                return Single.error(serviceError)
            })
    }

    var logoutHandler: (() -> Void)?
    
    func signOut() {
        invalidateTokens()
        logoutHandler?()
    }
    
    func setRegistration(passed: Bool) {
        self.accountStorage.registered = passed
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
    
    var numberRefreshTokenAttempts: Int {
        return 3
    }
    
    func getAccessToken() -> String {
        return (accountStorage.accessToken ?? "")
    }
    
    func refreshToken() -> Single<Void>? {
        if let token = accountStorage.refreshToken {
            return accountProvider.rx.request(.refreshToken(refreshToken: token ))
                .flatMap({[weak self]
                    response in
                    if let tokens = try? response.map(TokenResponse.self) {
                        self?.accountStorage.accessToken = tokens.accessToken
                        self?.accountStorage.refreshToken = tokens.refreshToken
                        return Single.just(())
                    } else {
                        throw AccountServiceError.noTokenError
                    }
                })
        } else {
            return nil
        }
    }
    
    func clearTokensAndHandleLogout() {
        signOut()
    }
}

