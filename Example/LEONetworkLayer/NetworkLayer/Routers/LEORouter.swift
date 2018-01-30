import Foundation

protocol LEORouter: RequestRouter {}

extension LEORouter {
    func baseUrl() -> URL {
		return URL(string: "\(Constants.get.apiBaseURL)/\(Constants.get.apiVersion)")!
    }
}
