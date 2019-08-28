import Moya
import enum Result.Result
import RxSwift

public protocol ILeoResponse {
    var isNotAuthorized: Bool {get}
    func parseSuccess() -> Result<Response, MoyaError>?
    func checkServerError() -> Result<Response, MoyaError>?
    func decodeData<T:Codable>(_ type: T.Type) -> T?
}


enum DataKey: String, CodingKey {
    case data
}

extension Response: ILeoResponse {
    
    public func decodeData<T:Codable>(_ type: T.Type) -> T? {
        return try? JSONDecoder().decode(T.self, from: self.data)
    }
    
    public var isNotAuthorized: Bool {
        return self.statusCode == 401
    }
    
    public func checkServerError() -> Result<Response, MoyaError>? {
        var result: Result<Response, MoyaError>? = nil
        if (self.statusCode >= 500) && (self.statusCode <= 599) {
            result = .failure(MoyaError.underlying(LeoProviderError.serverError, self))
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
                if let baseError = try? self.map(LeoBaseError.self) {
                    baseError.configureWithResponse(self)
                    result = .failure(MoyaError.underlying(LeoProviderError.leoBaseError(baseError), self))
                } else {
                    result = .failure(MoyaError.underlying(LeoProviderError.badLeoResponse, self))
                }
            }
        }
        
        if result == nil {
            if isNotAuthorized {
                result = .failure(MoyaError.underlying(LeoProviderError.securityError, self))
            }
        }
        return result
    }
    
    public func parseSuccess() -> Result<Response, MoyaError>? {
        print(self.statusCode)
        var result: Result<Response, MoyaError>? = nil
        
        if (self.statusCode >= 200) && (self.statusCode <= 299) {
            if let baseObject = try? self.map(LeoBaseObject.self) {
                if baseObject.success {
                    if let json = try? self.mapJSON(failsOnEmptyData: false) as? [String:AnyObject] {
                        if let jsonData = json[DataKey.data.rawValue] {
                            if let newData = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted) {
                                let dataResponse = Response(statusCode: self.statusCode, data: newData, request: self.request, response: self.response)
                                result = .success(dataResponse)
                            }
                        }
                    }
                }
            }
            
            if result == nil {
                result = .failure(MoyaError.underlying(LeoProviderError.badLeoResponse, self))
            }
        }
        return result
    }
}
