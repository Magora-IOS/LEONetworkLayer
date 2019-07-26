//
//  AccountService.swift
//  Example
//
//  Created by Yuriy Savitskiy on 7/24/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//


//Simple mock of the service
import Foundation

protocol AccountService {
    var isAuthenticated: Bool { get }
    var logoutHandler: (() -> Void)? { get set }
    func login()
    func signOut()
}

class AccountServiceImpl: AccountService {
    private let loginKey = "login"
    
    var isAuthenticated: Bool {
        return  UserDefaults.standard.bool(forKey: loginKey)
    }
    
    func login() {
        UserDefaults.standard.set(true, forKey: loginKey)
    }
    
    var logoutHandler: (() -> Void)?
    
    func signOut() {
        UserDefaults.standard.set(false, forKey: loginKey)
        logoutHandler?()
    }
    
    init() {
    }
    
}
