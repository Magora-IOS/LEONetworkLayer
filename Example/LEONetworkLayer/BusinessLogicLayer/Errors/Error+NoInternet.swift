import Foundation
import LEONetworkLayer



extension Error {
    
    
    var isNoInternet: Bool {
        
        if let object = self as? ErrorProtocol {
            return object.underlyingError?.isNoInternet ?? false
            
        } else if let leo = self as? LEONetworkLayer.NetworkLayerError {
            if case let LEONetworkLayer.NetworkLayerError.connectionFail(reason) = leo {
                return reason == .noConnection
            } else {
                return false
            }
            
        } else {
            return false
        }
    }
}
