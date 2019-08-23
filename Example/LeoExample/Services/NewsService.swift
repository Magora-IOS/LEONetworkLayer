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
    func getNews(cursor: CursorRequestParameters) -> Single<[News]>
}

class NewsService: INewsService {
    var tokenManager: ILeoTokenManager
    
    lazy private var newsProvider = LeoProviderFactory<NewsTarget>().makeProvider(tokenManager: self.tokenManager)
    lazy private var mockNewsProvider = LeoProviderFactory<NewsTarget>().makeProvider(mockType: .delayed(seconds: 1.0))
    
    init(tokenManager: ILeoTokenManager) {
        self.tokenManager = tokenManager
    }
    
    func requestMap<T:Codable>(_ input: T.Type, target: NewsTarget, mock: Bool = false) -> Single<T> {
        let provider = mock ? mockNewsProvider : newsProvider
        return provider.rx.request(target).map(T.self).catchError({ error in
            return Single.error(AccountServiceError.commonError(error))
        })
    }
    
    func getNews(cursor: CursorRequestParameters) -> Single<[News]> {
        
        return newsProvider.rx.request(.getNews(cursor: cursor)).flatMap({
            response in
            
            if let tokens = try? response.map(LeoArrayRegular<NewsResponse>.self) {
                print("ok")
            } else {
                throw AccountServiceError.noTokenError
            }
            
            return Single.error(AccountServiceError.noTokenError)
        }).catchError({ error in
            return Single.error(AccountServiceError.commonError(error))
        })
        
        
/*
        return requestMap(Leo2ArrayRegular<NewsDTO>.self, target: .getNews(cursor: cursor), mock: false).flatMap({
                response in
                Single.error(AccountServiceError.noTokenError)
            }).catchError({ error in
            return Single.error(AccountServiceError.commonError(error))
        })
  */
        
        return newsProvider.rx.request(.getNews(cursor: cursor)).flatMap({
            response in
            Single.error(AccountServiceError.noTokenError)
        }).catchError({ error in
            return Single.error(AccountServiceError.commonError(error))
        })
        
        //return requestMap(LeoArrayRegular<NewsDTO>.self, target: .getNews(cursor: cursor), mock: false)
    }
    
    func getNews(id: String) -> Single<News> {
        return newsProvider.rx.request(.getOneNews(id)).flatMap({
            response in
            Single.error(AccountServiceError.noTokenError)
        }).catchError({ error in
            return Single.error(AccountServiceError.commonError(error))
        })
    }
}

