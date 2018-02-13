import Alamofire



protocol RequestRouter: URLRequestConvertible {
    
    var method: HTTPMethod { get }
    var path: String { get }
    func baseUrl() -> URL
    var fullUrl: URL { get }
}



extension RequestRouter {
    
    var fullUrl: URL {
        return self.baseUrl().appendingPathComponent(self.path)
    }
    
    
    func createUrlWithParameters(_ param: () -> Parameters? ) throws -> URLRequest {
        var result = URLRequest(url: self.fullUrl)
        result.httpMethod = self.method.rawValue
        
        var encoding: ParameterEncoding?
        var contentType: String?
        
        switch self.method {
        case .get:
            encoding = URLEncoding()
            contentType = "application/x-www-form-urlencoded"
            
        default:
            encoding = JSONEncoding()
            contentType = "application/json"
        }
        
        
        let error = ErrorObject(domain: "RequestRouter")
        guard contentType != nil else {
            error.desc = "contentType isn't set"
            throw error
        }
        result.setValue(contentType!, forHTTPHeaderField: "Content-Type")
        
        guard encoding != nil else {
            error.desc = "encoding isn't set"
            throw error
        }
        result = try encoding!.encode(result, with: param())
        
        return result
    }
}

