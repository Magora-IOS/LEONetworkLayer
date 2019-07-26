//
//  LeoProvider.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/25/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import Moya

enum LeoMock {
    case none
    case immediately
    case delay(TimeInterval)
}

class LeoProvider<T:TargetType>: MoyaProvider<T> {
    
    static func authToken() -> String {
        return "pseudoToken"
    }
    
    init(token:Bool = true, mockType: LeoMock = .none) {
        
        var mockClosure: StubClosure
        switch mockType {
            case LeoMock.none:
                mockClosure = MoyaProvider<T>.neverStub
            case LeoMock.immediately:
                mockClosure = MoyaProvider<T>.immediatelyStub
            case LeoMock.delay(let seconds):
                mockClosure = MoyaProvider<T>.delayedStub(seconds)
        }        
        super.init(stubClosure: mockClosure, plugins: [AccessTokenPlugin(tokenClosure: LeoProvider<T>.authToken), LeoErrorPlugin()])
    }
}
