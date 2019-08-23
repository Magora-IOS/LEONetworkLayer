//
//  MainCoordinator.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import BaseCoordinator
import RxSwift

class MainCoordinator: BaseCoordinator {
    typealias Router = UINavigationController
    
    private var router: Router
    private let context: AppContext
    private var disposeBag = DisposeBag()
    
    override func start() {
        let viewModel = NewsViewModel(context: context)
        
        viewModel.onExit.bind(onNext: {[weak self] _ in
             self?.context.accountService.signOut()
        }).disposed(by: disposeBag)
        
        let viewController = MainViewController(viewModel: viewModel)
        router.pushViewController(viewController, animated: true)
    }
    
    init(router: Router, context: AppContext) {
        self.router = router
        self.context = context
        super.init()
    }
    
}

