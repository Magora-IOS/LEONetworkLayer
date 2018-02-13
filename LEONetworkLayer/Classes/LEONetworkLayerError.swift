public enum LEONetworkLayerError: Error {
    
    public enum ConnectionFailReasons {
        case noConnection
        case unknown
    }
    
    case unknown
    case badResponse(message: String?)
    case connectionFail(reason: ConnectionFailReasons)
    case businessProblem(code: LEOApiGlobalErrorCode, errors:[LEOError]?)
}

