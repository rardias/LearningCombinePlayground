import Foundation

extension String {
    public func toUrlComponents(_ path: String, queryItems: [String: String] = [:]) -> URL {
        var urlComponents = URLComponents(string: self)!
        urlComponents.path = "/\(path)"
        
        var queries: [URLQueryItem] = []
        for item in queryItems {
            queries.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        urlComponents.queryItems = queries
        return urlComponents.url!
    }
}
