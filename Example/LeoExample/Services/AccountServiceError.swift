//
//  AccountServiceError.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer

enum AccountServiceError: ILeoError {
   case noTokenError
   case noAuthDataError
   case commonError(Error)
}

extension AccountServiceError: ILeoLocalizedError {
    var info: (title: String, description: String?) {
        switch self {
        case .noTokenError:
            return (title: L10n.Errors.AccountService.commonTitle, description: L10n.Errors.AccountService.TokenFailed.description)
        case .noAuthDataError:
            return (title: L10n.Errors.AccountService.commonTitle, description: L10n.Errors.AccountService.NoAuth.description)
        case .commonError(let error):
            if let leoError = error.localizedLeoError {
                return leoError.info
            }
            return (title: L10n.Errors.Unknown.title, description: L10n.Errors.Unknown.description)
        }
    }
}

