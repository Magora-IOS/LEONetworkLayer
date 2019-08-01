//
//  LeoProviderError+Description.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/31/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer

extension LeoProviderError: ILeoLocalizedError {
    public var info: (title: String, description: String?) {
        var result: (title: String, description: String?)
        switch self {
        case .serverError:
            result.title = L10n.Errors.LeoProvider.ServerError.title
            result.description = L10n.Errors.LeoProvider.ServerError.description
        case .securityError:
            result.title = L10n.Errors.LeoProvider.SecurityError.title
            result.description = L10n.Errors.LeoProvider.SecurityError.description
        case .badLeoResponse:
            result.title = L10n.Errors.LeoProvider.BadLeoResponse.title
            result.description = L10n.Errors.LeoProvider.BadLeoResponse.description
        default:
            result.title = String(describing: self)
            result.description = nil
        }
        return result
    }       
}


