//
//  AuthenticationViewModel.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/25/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import LEONetworkLayer


enum AuthenticationViewModelState {
    case welcome
    case confirmation(String)
    case loading
    case dataError(String)
    case finished
}

class AuthenticationViewModel {
    let state: BehaviorRelay<AuthenticationViewModelState>
    let message = BehaviorRelay<String?>(value: nil)
    let title = BehaviorRelay<String?>(value: nil)
    let onSendPhoneEvent = PublishRelay<Void>()
    let onSendPinEvent = PublishRelay<Void>()
    let onSuccessPhoneEvent = PublishRelay<String>()
    let onSuccessPinEvent = PublishRelay<Void>()
    let number = BehaviorRelay<String?>(value: nil)
    let disposeBag = DisposeBag()
    private let phoneNumber: String
    
    private let context: Context
    typealias Context = IAccountServiceContext
    
    init(context: Context, startState: AuthenticationViewModelState) {
        self.context = context
        self.state = BehaviorRelay<AuthenticationViewModelState>(value: startState)
        
        if case AuthenticationViewModelState.confirmation(let phone) = startState {
            self.phoneNumber = phone
            self.message.accept(L10n.Authentication.Code.message)
        } else {
            self.phoneNumber = ""
            self.message.accept(L10n.Authentication.Welcome.message)
        }
        
        self.setupRx()
    }
    
    private func setupRx() {
        onSendPhoneEvent.withLatestFrom(number)
            .bind(onNext: {[weak self] number in
                if let `self` = self {
                    if let number = number {
                        self.state.accept(.loading)
                        self.context.accountService.sendPhone(phone: number).subscribe({[weak self] event in
                            switch event {
                            case let .success(response):
                                self?.state.accept(.finished)
                                self?.context.accountService.setRegistration(passed: response.signUp)
                                self?.onSuccessPhoneEvent.accept(number)
                            case let .error(error):
                                if let error = error as? AccountServiceError {
                                    self?.state.accept(.dataError(error.infoString))
                                }
                            }
                            }).disposed(by: self.disposeBag)
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        
        onSendPinEvent.withLatestFrom(number)
            .bind(onNext: {[weak self] number in
                if let `self` = self {
                    if let number = number {
                        self.state.accept(.loading)
                        self.context.accountService.signIn(phone: self.phoneNumber, code: number).subscribe({[weak self] event in
                            switch event {
                            case .success(_):
                                self?.state.accept(.finished)
                                self?.onSuccessPinEvent.accept(())
                            case let .error(error):
                                if let error = error as? AccountServiceError {
                                    self?.state.accept(.dataError(error.infoString))
                                } else {
                                    self?.state.accept(.dataError(L10n.Errors.Unknown.description))
                                }
                            }
                        }).disposed(by: self.disposeBag)
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
    }
    
}
