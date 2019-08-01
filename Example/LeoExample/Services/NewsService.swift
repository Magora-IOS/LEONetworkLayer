//
//  NewsService.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/29/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import LEONetworkLayer

protocol INewsService {
    
}

class NewsService: INewsService {
    var tokenManager: ILeoTokenManager
    
    lazy private var userProvider = LeoProvider<NewsTarget>(tokenManager: self.tokenManager)
    
    init(tokenManager: ILeoTokenManager) {
        self.tokenManager = tokenManager
    }
}
