//
//  MoyaError_Localization.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/1/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer
import Moya

extension MoyaError: ILeoLocalizedError {
    public var info: (title: String, description: String?) {
        var result: (title: String, description: String?)
        switch self {
        case .objectMapping(_, _):
            result.title = L10n.Errors.Moya.Parsing.title
            result.description = L10n.Errors.Moya.Parsing.description
        case .jsonMapping(_):
            result.title = L10n.Errors.Moya.Parsing.title
            result.description = L10n.Errors.Moya.Parsing.description
        default:
            return (title: String(describing: self), description: self.localizedDescription)
        }
        return result        
    }
}
