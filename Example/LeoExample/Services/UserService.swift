//
//  UserService.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/29/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import LEONetworkLayer


protocol IUserService {
    
}

class UserService: IUserService {
    var tokenManager: ILeoTokenManager
    
    lazy private var userProvider = LeoProvider<AuthentificationTarget>(tokenManager: self.tokenManager)
    
    init(tokenManager: ILeoTokenManager) {
        self.tokenManager = tokenManager
    }
}
