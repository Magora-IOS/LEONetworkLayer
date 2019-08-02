import Moya
import enum Result.Result
import RxSwift

public protocol ILeoResponse {
    var isNotAuthorized: Bool {get}
    func parseSuccess() -> Result<Response, MoyaError>?
    func checkServerError() -> Result<Response, MoyaError>?
    func decodeData<T:Codable>(_ type: T.Type) -> T?
}


extension Response: ILeoResponse {
    
    public func decodeData<T:Codable>(_ type: T.Type) -> T? {
        return try? JSONDecoder().decode(T.self, from: self.data)
    }
    
    public var isNotAuthorized: Bool {
        return self.statusCode == 401
    }
    
    public func parseErrors() -> Result<Response, MoyaError>? {
        var result: Result<Response, MoyaError>? = nil
        if let baseObject = try? self.map(LeoBaseObject.self) {
            switch baseObject.code {
            case .success:
                result = nil
            default:
                if let baseError = try? self.map(LeoBaseError.self) {
                    print("oki")                    
                } else {
                    result = .failure(MoyaError.underlying(LeoProviderError.badLeoResponse, self))
                }
            }
        } else {
            result = .failure(MoyaError.underlying(LeoProviderError.badLeoResponse, self))
        }
        return result
    }
    
    public func parseSuccess() -> Result<Response, MoyaError>? {
        print(self.statusCode)
        var result: Result<Response, MoyaError>? = nil
        
        if (self.statusCode >= 200) && (self.statusCode <= 299) {
            //print(String(data: self.data, encoding: .utf8))
            
            if let baseObject = try? self.map(LeoBaseObject.self) {
                print(baseObject.code)
            }
            
            result = .failure(MoyaError.underlying(LeoProviderError.badLeoResponse, self))
        }
        return result
    }
    
    public func checkServerError() -> Result<Response, MoyaError>? {
        var result: Result<Response, MoyaError>? = nil
        if (self.statusCode >= 500) && (self.statusCode <= 599) {
            result = .failure(MoyaError.underlying(LeoProviderError.serverError, self))
        }
        return result
    }        
}
