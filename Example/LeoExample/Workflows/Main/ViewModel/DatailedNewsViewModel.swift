//
//  OneNewsViewModel.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum DetailedNewsViewModelState {
    case start
    case loading
    case dataError(String)
    case finished(News)
}

class DetailedNewsViewModel {
    
    private let context: Context
    typealias Context = INewsServiceContext
    
    var disposeBag = DisposeBag()
    let state = BehaviorRelay<DetailedNewsViewModelState>(value: .start)
    var news: News
    
    init(context: Context, news: News) {
        self.context = context
        self.news = news
        self.refresh()
    }
    
    func refresh() {
        self.context.newsService.getNews(id: self.news.id).subscribe({[weak self] event in
            switch event {
            case .success(let news):                
                self?.state.accept(.finished(news))
            case let .error(error):
                if let error = error as? NewsServiceError {
                    self?.state.accept(.dataError(error.infoString))
                } else {
                    self?.state.accept(.dataError(L10n.Errors.Unknown.title))
                }
            }
        }).disposed(by: self.disposeBag)
    }
}
