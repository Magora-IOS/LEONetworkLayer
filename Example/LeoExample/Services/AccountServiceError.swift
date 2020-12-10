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
    case codeExpired(LeoApiError)
    case invalidSmsCode(LeoApiError)
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
        case .codeExpired:
            return (title: L10n.Errors.AccountService.commonTitle, description: L10n.Errors.AccountService.CodeExpired.description)
        case .invalidSmsCode:
            return (title: L10n.Errors.AccountService.commonTitle, description: L10n.Errors.AccountService.InvalidSmsCode.description)
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
        if let serviceError = error as? AccountServiceError {
            return serviceError
        }
        
        if let baseLeoError = error.baseLeoError {
            if let anyAPiError = baseLeoError.errors?.first {
                switch anyAPiError.rawCode {
                case "sec.invalid_code":
                    return .invalidSmsCode(anyAPiError)
                case "code_expired":
                    return .codeExpired(anyAPiError)
                default:
                    return .apiError(anyAPiError)
                }
            }
        }
        return .commonError(error)
    }
}

