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
    let detailRequested = PublishRelay<News>()
    
    private let pageSize = 15
    private var total: Int = 0
    private var currentPage: Int = 1
    
    var loading: Bool {
        if case .loading = self.state.value {
            return true
        } else {
            return false
        }
    }
    
    var itemsCount: Int {
        return items.value.count
    }
    
    init(context: Context) {
        self.context = context
        self.refresh()
    }

    func exit() {
        self.onExit.accept(())
    }

    func loadMore() -> Bool {
        if self.itemsCount < self.total {
            if !loading {
                self.currentPage += 1
                self.loadData(page: self.currentPage)
                return true
            }
        }
        return false
    }
    
    func refresh() {
       self.currentPage = 1
       self.loadData(page: self.currentPage)
        self.loadData(page: 2)
        self.loadData(page: 3)
        
    }
    
    private func loadData(page: Int) {
        let cursor = CursorRequestParameters(page: page, pageSize: self.pageSize)
        self.state.accept(.loading)
        self.context.newsService.getNews(cursor: cursor).subscribe({ [weak self] event in
            if let `self` = self {
                switch event {
                case .success(let currentData):
                    let oldValues = self.items.value
                    if page > 1 {
                        self.items.accept(oldValues + currentData.news)
                    } else {
                        self.items.accept(currentData.news)
                    }
                    if let total = currentData.total {
                        self.total = total
                    }
                    self.state.accept(.finished)
                case let .error(error):
                    if let error = error as? NewsServiceError {
                        self.state.accept(.dataError(error.infoString))
                    } else {
                        self.state.accept(.dataError(L10n.Errors.Unknown.title))
                    }
                }
            }
        }).disposed(by: self.disposeBag)
    }
}
