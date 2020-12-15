//
//  NewsServiceError.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/23/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer

enum NewsServiceErrorCode: Int, IBaseErrorCode {
    case otherError = 0
}

class NewsServiceError: BaseError<NewsServiceErrorCode> {
    public override var domainShortname: String {
        "NSE"
    }
}

extension NewsServiceError: ILeoLocalizedError {
    var info: (title: String, description: String?) {
        switch self.errorCode {
        case .otherError:
            return self.underlyingLocalizedInfo()
        }
    }
}

