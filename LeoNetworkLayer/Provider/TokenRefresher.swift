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
    private static let queue = DispatchQueue(label: "ThreadSafeObservers.queue", qos: .utility)
    
    private static var refreshing: Bool = false
    private static var currentTokenRefreshing: Completable? = nil
    
    static private var observersStack: [(CompletableEvent) -> Void] = []
    
    static private func pushObserver(_ input: @escaping (CompletableEvent) -> Void) {
        queue.async() {            
            self.observersStack.append(input)
        }
    }
    
    static private func popObserver() -> ((CompletableEvent) -> Void)? {
        var result: ((CompletableEvent) -> Void)? = nil
        queue.sync() {
            result = self.observersStack.popLast()
        }
        return result
    }
    
    static func start(getNewTokens: Completable, observer: @escaping (CompletableEvent) -> Void) {
        if !self.refreshing {
            self.refreshing = true
            getNewTokens.subscribe { completable in
                //self static
                observer(completable)
                while let observer = self.popObserver() {
                    observer(completable)
                }
                self.refreshing = false
                }.disposed(by: self.disposeBag)
        } else {
            self.pushObserver(observer)
        }
    }
}
