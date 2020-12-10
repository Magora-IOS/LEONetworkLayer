//
//  NewsTarget.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/29/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import LEONetworkLayer
import Moya

enum NewsTarget {
    case getOneNews(id: String)
    case getNews(cursor: CursorRequestParameters)
}

extension NewsTarget: ILeoTargetType, ILeoCachePolicy {
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
        case .getOneNews:
            return .returnCacheDataElseLoad
        default:
            return .useProtocolCachePolicy
        }
    }
    
    var path: String {
        switch self {
        case .getOneNews(let id): return "news/\(id)"
        case .getNews: return "news"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getOneNews, .getNews:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getOneNews:
            return .requestPlain
        case .getNews(let cursor):
            return .requestParameters(parameters: cursor.toDictionary() ?? [:], encoding: URLEncoding.default)                
        }
    }

    var sampleData: Data {
        switch self {
        case .getOneNews:
            let str = """
            {"name": "name","id":3}
            """
            return str.data(using: .utf8)!
        case .getNews:
            let str = """
            {"name": "name","id":3}
            """
            return str.data(using: .utf8)!
        }
    }
}


