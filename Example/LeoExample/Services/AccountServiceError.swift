//
//  AccountServiceError.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/2/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer

enum AccountServiceErrorCode: Int, IBaseErrorCode {
    case noTokenError = 0
    case noAuthDataError = 1
    case codeExpired = 2
    case invalidSmsCode = 3
    case apiError = 4
    case otherError = 5
}

class AccountServiceError: BaseError <AccountServiceErrorCode> {
    public override var domainShortname: String {
        "ASE"
    }
}

extension AccountServiceError: ILeoLocalizedError {
    var info: (title: String, description: String?) {
        switch self.errorCode {
        case .noTokenError:
            return (title: L10n.Errors.AccountService.commonTitle, description: L10n.Errors.AccountService.TokenFailed.description)
        case .noAuthDataError:
            return (title: L10n.Errors.AccountService.commonTitle, description: L10n.Errors.AccountService.NoAuth.description)
        case .codeExpired:
            return (title: L10n.Errors.AccountService.commonTitle, description: L10n.Errors.AccountService.CodeExpired.description)
        case .invalidSmsCode:
            return (title: L10n.Errors.AccountService.commonTitle, description: L10n.Errors.AccountService.InvalidSmsCode.description)
        case .apiError:
            return self.underlyingLocalizedInfo()
        case .otherError:
            return self.underlyingLocalizedInfo()
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
                var apiError: AccountServiceErrorCode = .apiError
                switch anyAPiError.rawCode {
                case "sec.invalid_code":
                    apiError = .invalidSmsCode
                case "code_expired":
                    apiError = .codeExpired
                default:
                    apiError = .apiError
                }
                
                return AccountServiceError(code: apiError, underlyingError: anyAPiError)
            }
        }
        
        return AccountServiceError(code: .otherError, underlyingError: error)
    }
}

