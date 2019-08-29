import Foundation
import Moya

public protocol ILeoTargetType: TargetType, AccessTokenAuthorizable {
    var baseURL: URL { get }
    var authorization: AuthorizationType { get }
}

public extension ILeoTargetType {
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .none
    }

    var sampleData: Data {
        return LeoMockResponse.emptySuccess
    }

    var authorizationType: AuthorizationType {
        return authorization
    }
}

