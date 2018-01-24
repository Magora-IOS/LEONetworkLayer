enum NetworkLayerError: Error {
    
    enum ConnectionFailReasons {
        case noConnection
        case unknown
    }
    
    case unknown
    case badResponse
    case connectionFail(reason: ConnectionFailReasons)
    case businessProblem(code: LEOApiGlobalErrorCode, errors:[LEOError]?)
}
