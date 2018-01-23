import Alamofire

extension DataRequest {
    
    @discardableResult
    public func validateLEOErrors() -> Self {
        return validate { (request, respons, data) -> Request.ValidationResult in
            
            guard let jsonData = data,
                let jsonString = String(data: jsonData, encoding: .utf8),
                let baseResponse = LEOBaseResponse(JSONString: jsonString) else {
                    return .failure(NetworkLayerError.badResponse)
            }
            
            if let code = baseResponse.code, code != .success {
                return .failure(NetworkLayerError.businessProblem(code: code, errors: baseResponse.errors))
            }
            
            return .success
        }
    }
}

