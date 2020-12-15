//
//  NewsService.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/29/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import LEONetworkLayer
import RxSwift

protocol INewsService {
    func getNews(id: String) -> Single<News>
    func getNews(cursor: CursorRequestParameters) -> Single<(news: [News], total: Int?)>
}

class NewsService: INewsService {
    var tokenManager: ILeoTokenManager

    lazy private var newsProvider = LeoProviderFactory<NewsTarget>().makeProvider(tokenManager: self.tokenManager)
    lazy private var mockNewsProvider = LeoProviderFactory<NewsTarget>().makeProvider(mockType: .delayed(seconds: 1.0))

    init(tokenManager: ILeoTokenManager) {
        self.tokenManager = tokenManager
    }

    func requestMap<T: Decodable>(_ input: T.Type, target: NewsTarget, mock: Bool = false) -> Single<T> {
        let provider = mock ? mockNewsProvider : newsProvider
        return provider.rx.request(target).map(T.self).catchError({ error in
            let newsServiceError = NewsServiceError(code: .otherError, underlyingError: error)
            return Single.error(newsServiceError)
        })
    }

    func getNews(cursor: CursorRequestParameters) -> Single<(news: [News], total: Int?)> {
        return requestMap(LeoArrayRegular<NewsResponse>.self, target: .getNews(cursor: cursor)).flatMap({
            response in
            let items: [NewsDTO] = response.items.map({ $0.news })
            return Single.just((items.map(News.init), response.total))
        })
    }

    func getNews(id: String) -> Single<News> {
        return requestMap(NewsResponse.self, target: .getOneNews(id: id))
                .map({ News($0.news) })
    }
}

