import Alamofire
import AlamofireObjectMapper
import ObjectMapper

enum Response<T> {
    case Success(T)
    case Error(Error)
}

extension DataRequest {
    
    @discardableResult
    internal func responseLEO<T: LEOBaseResponse>( completionHandler: @escaping (Response<T>) -> Void) -> Self {
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
                if error is NetworkLayerError {
                    completionHandler(.Error(error))
                } else {
                    let leoError = self.getNetworkError(error: error)
                    completionHandler(.Error(leoError))
                }
                break
            }
        }
    }
    
    private func getNetworkError(error: Error) -> NetworkLayerError {
        
        switch (error as NSError).code {
        case -1010 ... -1000:
            return NetworkLayerError.connectionFail(reason: .noConnection)
        default:
            return NetworkLayerError.connectionFail(reason: .unknown)
        }
    }
    
    private func getNetworkError(formData data: Data?) -> NetworkLayerError {
        
        guard let jsonData = data, let jsonString = String(data: jsonData, encoding: .utf8) else {
            return NetworkLayerError.badResponse
        }
        if let baseResponse = LEOBaseResponse(JSONString: jsonString) {
            return baseResponse.getNetworkError()
        }
        return NetworkLayerError.unknown
    }
    
}
