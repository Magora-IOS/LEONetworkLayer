//
//  MoyaCachePlugin.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 1/31/20.
//  Copyright © 2020 Yuriy Savitskiy. All rights reserved.
//

import Moya

public protocol ILeoCachePolicy {
  var cachePolicy: URLRequest.CachePolicy { get }
}

open class LeoCachePlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let target = target as? ILeoCachePolicy {
            var cacheRequest = request
            cacheRequest.cachePolicy = target.cachePolicy
            return cacheRequest
        }
        return request
    }
}
