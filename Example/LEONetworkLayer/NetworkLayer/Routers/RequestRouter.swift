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
    
    
    func createUrlWithParameters(_ params: () -> Parameters? ) throws -> URLRequest {
        var result = URLRequest(url: self.fullUrl)
        result.httpMethod = self.method.rawValue
        
        var encoding: ParameterEncoding?
        var contentType: String?
        
        switch self.method {
        case .get, .head, .options, .trace, .delete:
            encoding = URLEncoding()
            
        case .post, .put, .patch:
            encoding = JSONEncoding()
            contentType = "application/json"
            
        case .connect:
            //TODO: clear this
            break
        }
        
        
        if let contentType = contentType {
            result.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        let error = ErrorObject(domain: "RequestRouter")
        guard encoding != nil else {
            error.desc = "encoding isn't set"
            throw error
        }
        result = try encoding!.encode(result, with: params())
        
        return result
    }
}

