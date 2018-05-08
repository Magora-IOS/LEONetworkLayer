import Alamofire



extension DataRequest {
    
    
    @discardableResult
    public func leo_logRequestCURL(_ logger: (String)->()) -> Self {
        logger(self.debugDescription)
        return self
    }
    
    
    @discardableResult
    public func leo_logResponse(_ logger: @escaping (String)->()) -> Self {
        return self.responseString {
            logger($0.description)
        }
    }
    
    
    
    @discardableResult
    public func leo_logRequestAndResponse(_ logger: @escaping (String)->()) -> Self {
        return self.responseString {
            logger(self.debugDescription + "\n" + $0.description)
        }
    }
    

    
}
