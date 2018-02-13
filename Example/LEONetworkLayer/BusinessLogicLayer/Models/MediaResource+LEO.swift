import Foundation
import LEONetworkLayer




extension MediaResource {
    
    init?(leo: LEOMediaResource?) {
        guard let leo = leo else {
            return nil
        }
        
        contentType = leo.contentType
        originalUrl = leo.originalUrl
        
        //TODO: throw exception?
        if let source = leo.formatUrls {
            var formatUrlsTemp = [Int: URL]()
            for (widthString, urlString) in source {
                guard let width = Int(widthString) else {
                    continue
                }
                guard let url = URL(string: urlString) else {
                    continue
                }
                formatUrlsTemp[width] = url
            }
            formatUrls = formatUrlsTemp
        } else {
            formatUrls = [:]
        }
    }
    
    
}


