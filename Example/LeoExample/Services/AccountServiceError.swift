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
   case apiError(LeoApiError)
   case commonError(Error)
}

extension AccountServiceError: ILeoLocalizedError {
    var info: (title: String, description: String?) {
        switch self {
        case .noTokenError:
            return (title: L10n.Errors.AccountService.commonTitle, description: L10n.Errors.AccountService.TokenFailed.description)
        case .noAuthDataError:
            return (title: L10n.Errors.AccountService.commonTitle, description: L10n.Errors.AccountService.NoAuth.description)
        case .apiError(let apiError):
            return (title: apiError.message ?? "", description: nil)
        case .commonError(let error):
            if let leoError = error.localizedLeoError {
                return leoError.info
            }
            return (title: L10n.Errors.Unknown.title, description: L10n.Errors.Unknown.description)
        }
    }
    }

extension AccountServiceError {
    static func convertError(_ error: Error) -> AccountServiceError {
        if let baseLeoError = error.baseLeoError {
            if let anyAPiError = baseLeoError.errors?.first {
               return AccountServiceError.apiError(anyAPiError)
            }
        }
        return AccountServiceError.commonError(error)
    }
}

