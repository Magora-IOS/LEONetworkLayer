//
//  RegistrationViewModel.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/25/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RegistrationViewModelState {
    case start
    case loading
    case dataError(String)
    case finished
}

class RegistrationViewModel {
    private let context: Context
    typealias Context = IAccountServiceContext
    
    var name: String?
    var email: String?
    var zip: String?
    
    var disposeBag = DisposeBag()
    let onSuccessEvent = PublishRelay<Void>()
    let onExit = PublishRelay<Void>()
    let state = BehaviorRelay<RegistrationViewModelState>(value: .start)
    
    init(context: Context) {
        self.context = context
    }
    
    func sendData() {
        var userData = UserRegistrationInfoDTO()
        userData.name = self.name ?? ""
        userData.email = self.email ?? ""
        userData.zip = self.email ?? ""
        
        self.state.accept(.loading)
        
        self.context.accountService.registerUser(userData: userData).subscribe({[weak self] event in
            switch event {
            case .success(_):
                self?.context.accountService.setRegistration(passed: true)
                self?.state.accept(.finished)
                self?.onSuccessEvent.accept(())
            case let .error(error):
                if let error = error as? AccountServiceError {
                    self?.state.accept(.dataError(error.infoString))
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func exit() {
        self.onExit.accept(())
    }
}
