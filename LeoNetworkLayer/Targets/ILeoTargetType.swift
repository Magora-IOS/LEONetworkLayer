import Foundation
import Moya

public protocol ILeoTargetType: TargetType, AccessTokenAuthorizable {
    var defaultLeoAuthorization: AuthorizationType { get }
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

    var defaultLeoAuthorization: AuthorizationType {
        return .bearer
    }
    
    var authorizationType: AuthorizationType {
        return defaultLeoAuthorization
    }
}

