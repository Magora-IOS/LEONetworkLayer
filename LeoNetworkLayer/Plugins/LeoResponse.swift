import Moya
import RxSwift

public protocol ILeoResponse {
    var leoStatusCode: LeoStatusCode { get }
    func parseSuccess() -> Result<Response, MoyaError>?
    func checkServerError() -> Result<Response, MoyaError>?
    func decodeData<T: Codable>(_ type: T.Type) -> T?
}


enum DataKey: String, CodingKey {
    case data
}

extension Response: ILeoResponse {

    public func decodeData<T: Codable>(_ type: T.Type) -> T? {
        return try? JSONDecoder().decode(T.self, from: self.data)
    }
    
    
    public var leoStatusCode: LeoStatusCode {
        return LeoStatusCode.valueFrom(self.statusCode)
    }
    
    
    
    public func checkServerError() -> Result<Response, MoyaError>? {
        var result: Result<Response, MoyaError>? = nil
        if self.leoStatusCode.hasState(.internalError) {
            let serverError = LeoProviderError(code: .serverError)
            result = .failure(MoyaError.underlying(serverError, self))
        }
        return result
    }

    public func parseErrors() -> Result<Response, MoyaError>? {
        var result: Result<Response, MoyaError>? = nil

        if let baseObject = try? self.map(LeoBaseObject.self) {
            switch baseObject.code {
            case .success:
                result = nil
            default:
                if var baseError = try? self.map(LeoBaseError.self) {
                    baseError.configureWithResponse(self)                                    
                    let leoBaseError = LeoProviderError(code: .leoBaseError, underlyingError: baseError)
                    result = .failure(MoyaError.underlying(leoBaseError, self))
                } else {
                    let badLeoResponseError = LeoProviderError(code: .badLeoResponse)
                    result = .failure(MoyaError.underlying(badLeoResponseError, self))
                }
            }
        }

        if result == nil {
            if leoStatusCode.hasState(.securityError) {
                let securityError = LeoProviderError(code: .securityError)
                result = .failure(MoyaError.underlying(securityError, self))
            } else {
                if var leoBaseError = LeoBaseError.from(leoStatusCode) {
                    leoBaseError.configureWithResponse(self)
                    let error = LeoProviderError(code: .leoBaseError, underlyingError: leoBaseError)
                    result = .failure(MoyaError.underlying(error, self))
                }
            }
        }
        return result
    }

    public func parseSuccess() -> Result<Response, MoyaError>? {
        var result: Result<Response, MoyaError>? = nil
         if case .success = leoStatusCode {
            if let baseObject = try? self.map(LeoBaseObject.self) {
                if baseObject.success {
                    if let json = try? self.mapJSON(failsOnEmptyData: false) as? [String: AnyObject] {
                        if let jsonData = json[DataKey.data.rawValue] {
                            if jsonData is NSNull {
                            } else {
                                if let newData = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted) {
                                    let dataResponse = Response(statusCode: self.statusCode, data: newData, request: self.request,  response: self.response)
                                    result = .success(dataResponse)
                                }
                            }
                        }
                    }
                    
                    if result == nil {
                        let dataResponse = Response(statusCode: self.statusCode, data: Data(), request: self.request,  response: self.response)
                        result = .success(dataResponse)
                    }
                }
            }

            if result == nil {
                let badResultError = LeoProviderError(code: .badLeoResponse)
                result = .failure(MoyaError.underlying(badResultError, self))
            }
        }
        return result
    }
}
