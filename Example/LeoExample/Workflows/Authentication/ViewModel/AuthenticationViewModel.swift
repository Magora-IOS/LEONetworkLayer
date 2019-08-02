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
    case loading
    case confirmation
    case dataError(String)
    case finished
}

class AuthenticationViewModel {
    let state: BehaviorRelay<AuthenticationViewModelState>
    let message = BehaviorRelay<String?>(value: nil)
    let errorMessage = BehaviorRelay<String?>(value: nil)
    let title = BehaviorRelay<String?>(value: nil)
    let onNextEvent = PublishRelay<Void>()
    let onSuccessEvent = PublishRelay<Void>()
    let number = BehaviorRelay<String?>(value: nil)
    let disposeBag = DisposeBag()
    
    private let context: Context
    typealias Context = IAccountServiceContext
    
    init(context: Context, startState: AuthenticationViewModelState) {
        self.context = context
        self.state = BehaviorRelay<AuthenticationViewModelState>(value: startState)
        self.setupRx()
    }
    
    private func setupRx() {
        onNextEvent.withLatestFrom(number)
            .bind(onNext: {[weak self] number in
                if let `self` = self {
                    if let number = number {
                        self.context.accountService.sendPhone(phone: number).subscribe({[weak self] event in
                            switch event {
                            case let .success(response):
                                self?.onSuccessEvent.accept(())
                            case let .error(error):
                                if let error = error as? AccountServiceError {
                                    self?.errorMessage.accept(error.infoString)
                                }
                            }
                            }).disposed(by: self.disposeBag)
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
    
}
