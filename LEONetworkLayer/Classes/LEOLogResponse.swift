import Alamofire

extension DataRequest {
    
    @discardableResult
    public func logResponse(log: Bool = true) -> Self {
        return log ? self.responseString(completionHandler: { (data: DataResponse<String>) in
            print(data.description)
        }) : self
    }
    
    @discardableResult
    public func printRequestCURL() -> Self {
        print(self.debugDescription)
        return self
    }
    
}
