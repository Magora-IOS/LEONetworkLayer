//
//  NewsViewModel.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/22/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum NewsViewModelState {
    case start
    case loading
    case dataError(String)
    case finished
}

class NewsViewModel {
    
    private let context: Context
    typealias Context = INewsServiceContext
    
    var items = BehaviorRelay<[News]>(value: [])
    var onExit = PublishRelay<Void>()
    var disposeBag = DisposeBag()
    let state = BehaviorRelay<NewsViewModelState>(value: .start)
        
    init(context: Context) {
        self.context = context
        self.refresh()        
    }    

    func exit() {
        self.onExit.accept(())
    }
    
    func refresh() {
        let cursor = CursorRequestParameters(page: 1, pageSize: 5)
        self.context.newsService.getNews(cursor: cursor).subscribe({[weak self] event in
            switch event {
            case .success(_):
                print("ok")
            case let .error(error):
                if let error = error as? NewsServiceError {
                    self?.state.accept(.dataError(error.infoString))
                } else {
                    self?.state.accept(.dataError(L10n.Errors.Unknown.description))
                }
            }
        }).disposed(by: self.disposeBag)
    }
}
