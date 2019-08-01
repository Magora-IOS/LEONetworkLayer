//
//  AuthenticationCoordinator.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import BaseCoordinator
import RxSwift
import RxCocoa

class AuthenticationCoordinator: BaseCoordinator {
    private let router: UINavigationController
    private var context: AppContext
    private let disposeBag = DisposeBag()
    
    init(router: UINavigationController, context: AppContext) {
        self.router = router
        self.context = context
    }
    
    override func start() {
        if !self.context.accountService.isAuthenticated {
            startWelcome()
        } else {
            self.completionHandler?()
        }
    }
    
    // MARK: Starting modules
    private func startWelcome() {
        let viewModel = AuthenticationViewModel(context: self.context, startState: .welcome)
        viewModel.onSuccessEvent.bind(onNext: {[weak self] state in
            self?.startCode()
        })
            .disposed(by: disposeBag)
        
        let viewController = AuthenticationViewController(viewModel: viewModel)
        
        router.pushViewController(viewController, animated: true)
    }
    
    private func startCode() {
        let viewModel = AuthenticationViewModel(context: self.context, startState: .confirmation)
        viewModel.onNextEvent.bind(onNext: {[weak self] state in
            self?.completionHandler?()
        })
            .disposed(by: disposeBag)
        
        let viewController = AuthenticationViewController(viewModel: viewModel)
                
        router.pushViewController(viewController, animated: true)
    }
    
}
