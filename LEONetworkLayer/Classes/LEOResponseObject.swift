import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public enum Response<T> {
    case Success(T)
    case Error(Error)
}



extension DataRequest {
    
    @discardableResult
    public func responseLEO<T: LEOBaseResponse>( completionHandler: @escaping (Response<T>) -> Void) -> Self {
        return self.responseObject { (dataResponse: DataResponse<T>) in
            
            switch dataResponse.result {
            case let .success(data):
                if data.isSuccess {
                    completionHandler(.Success(data))
                } else {
                    let leoError = self.getNetworkError(formData: dataResponse.data)
                    completionHandler(.Error(leoError))
                }
                break
            case let .failure(error):
                if error is LEONetworkLayerError {
                    completionHandler(.Error(error))
                } else {
                    let leoError = self.getNetworkError(error: error)
                    completionHandler(.Error(leoError))
                }
                break
            }
        }
    }
    
    private func getNetworkError(error: Error) -> LEONetworkLayerError {
        
        switch (error as NSError).code {
        case -1010 ... -1000:
            return LEONetworkLayerError.connectionFail(reason: .noConnection)
        default:
            return LEONetworkLayerError.connectionFail(reason: .unknown)
        }
    }
    
    private func getNetworkError(formData data: Data?) -> LEONetworkLayerError {
        
        guard let jsonData = data, let jsonString = String(data: jsonData, encoding: .utf8) else {
            return LEONetworkLayerError.badResponse
        }
        if let baseResponse = try? LEOBaseResponse(JSONString: jsonString) {
            return baseResponse.getNetworkError()
        }
        return LEONetworkLayerError.unknown
    }
    
}
