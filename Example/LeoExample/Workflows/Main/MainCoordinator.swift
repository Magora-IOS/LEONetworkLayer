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
        
        viewModel.detailRequested.bind(onNext: {[weak self] news in
            self?.showDetailed(news: news)
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.onExit.bind(onNext: {[weak self] _ in
             self?.context.accountService.signOut()
        }).disposed(by: viewModel.disposeBag)
        
        let viewController = MainViewController(viewModel: viewModel)
        router.pushViewController(viewController, animated: true)
    }
    
    init(router: Router, context: AppContext) {
        self.router = router
        self.context = context
        super.init()
    }
 
    private func showDetailed(news: News) {
        let viewModel = DetailedNewsViewModel(context: context, news: news)
        let viewController = DetailedNewsViewController(viewModel: viewModel)
        router.pushViewController(viewController, animated: true)
    }
}

