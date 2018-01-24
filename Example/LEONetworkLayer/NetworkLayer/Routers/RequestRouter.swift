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
    
    func createUrlWithParametrs(_ param: () -> Parameters? ) throws -> URLRequest {
        var urlRequest = URLRequest(url: self.fullUrl)
        urlRequest.httpMethod = method.rawValue
        let encoding: ParameterEncoding = method == .get ? URLEncoding() : JSONEncoding()
        urlRequest = try encoding.encode(urlRequest, with: param())
        return urlRequest
    }
}
