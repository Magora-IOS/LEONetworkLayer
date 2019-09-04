//
//  TokenRefresher.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 9/4/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import RxSwift

internal class TokenRefresher {
    
    private static var disposeBag = DisposeBag()
    private static let queue = DispatchQueue(label: "ThreadSafeObservers.queue", attributes: .concurrent)
    
    private static var currentTokenRefreshing: Completable? = nil
    
    static private var observersStack: [(CompletableEvent) -> Void] = []
    static private func pushObserver(_ input: @escaping (CompletableEvent) -> Void) {
        queue.async(flags: .barrier) {
            self.observersStack.append(input)
        }
    }
    
    static private func popObserver() -> ((CompletableEvent) -> Void)? {
        var result: ((CompletableEvent) -> Void)? = nil
        queue.sync(flags: .barrier) {
            result = self.observersStack.popLast()
        }
        return result
    }
    
    static func start(refreshToken: Completable, observer: @escaping (CompletableEvent) -> Void) {
        if currentTokenRefreshing != nil {
            self.pushObserver(observer)
        } else {
            self.currentTokenRefreshing = refreshToken
            
            refreshToken.subscribe { completable in
                observer(completable)
                while let observer = self.popObserver() {
                    observer(completable)
                }
                self.currentTokenRefreshing = nil
                }.disposed(by: self.disposeBag)
        }
    }
}
