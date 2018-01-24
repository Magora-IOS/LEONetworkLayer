import Foundation

protocol RestRouter: RequestRouter {}

extension RestRouter {
    func baseUrl() -> URL {
		return URL(string: "\(Constants.get.apiBaseURL)/\(Constants.get.apiVersion)")!
    }
}
