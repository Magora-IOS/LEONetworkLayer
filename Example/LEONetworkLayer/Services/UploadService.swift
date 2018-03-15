import RxSwift



protocol UploadService {
   
    func upload(data: Data, contentType: String, url: URL) -> Observable<Void>
}




class UploadServiceImpl: UploadService {
    
    
    func upload(data: Data, contentType: String, url: URL) -> Observable<Void> {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.httpBody = data
        urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(String(data.count),
                            forHTTPHeaderField: "Content-Length")

        return Observable<Void>.create { observer -> Disposable in
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    observer.onError(error!)
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
