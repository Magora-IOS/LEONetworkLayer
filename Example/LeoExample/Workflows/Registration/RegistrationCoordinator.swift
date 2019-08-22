//
//  RegistrationCoordinator.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import BaseCoordinator
import RxSwift
import RxCocoa

class RegistrationCoordinator: BaseCoordinator {
    private let router: UINavigationController
    private let context: Context
    typealias Context = IAccountServiceContext
    private let disposeBag = DisposeBag()
    private var registered = false
    
    init(router: UINavigationController, context: Context) {
        self.router = router
        self.context = context
    }
    
    override func start() {
        let viewModel = RegistrationViewModel(context: self.context)
        
        viewModel.onSuccessEvent.bind(onNext: {[weak self] in            
            self?.completionHandler?()
        })
            .disposed(by: disposeBag)
        
        viewModel.onExit.bind(onNext: {[weak self] in
            self?.context.accountService.clearTokensAndHandleLogout()
            self?.completionHandler?()
        }).disposed(by: disposeBag)
        
        let viewController = RegistrationViewController(viewModel: viewModel)        
        router.pushViewController(viewController, animated: true)
    }
}
