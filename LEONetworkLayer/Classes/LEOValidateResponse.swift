import Alamofire

extension DataRequest {
    
    @discardableResult
    public func validateLEOErrors() -> Self {
        return validate { (request, respons, data) -> Request.ValidationResult in
            
            guard let jsonData = data,
                let jsonString = String(data: jsonData, encoding: .utf8),
                let baseResponse = try? LEOBaseResponse(JSONString: jsonString) else {
                    return .failure(NetworkLayerError.badResponse)
            }
            
            let code = baseResponse.code
            if code != .success {
                return .failure(NetworkLayerError.businessProblem(code: code, errors: baseResponse.errors))
            }
            
            return .success
        }
    }
}

