import Combine
import Foundation

public enum PlaceholderApi {
    case error
    case posts
    case postsByUserId(Int)
    case users
    case userByUserId(Int)
    
    static let baseUrl = "https://jsonplaceholder.typicode.com"
}

extension PlaceholderApi: RawRepresentable {
    public init?(rawValue: URLRequest) {
        switch rawValue {
            case URLRequest(url: PlaceholderApi.baseUrl.toUrlComponents("error")): self = .error
            case URLRequest(url: PlaceholderApi.baseUrl.toUrlComponents("posts")): self = .posts
            case URLRequest(url: PlaceholderApi.baseUrl.toUrlComponents("users")): self = .users
            default: return nil
        }
    }
    
    public var rawValue: URLRequest {
        switch self {
            case .error: return URLRequest(url: PlaceholderApi.baseUrl.toUrlComponents("error"))
            case .posts: return URLRequest(url: PlaceholderApi.baseUrl.toUrlComponents("posts"))
            case .postsByUserId(let userId): return URLRequest(url: PlaceholderApi.baseUrl.toUrlComponents("posts", queryItems: ["userId": "\(userId)"]))
            case .users: return URLRequest(url: PlaceholderApi.baseUrl.toUrlComponents("users"))
            case .userByUserId(let userId): return URLRequest(url: PlaceholderApi.baseUrl.toUrlComponents("users", queryItems: ["id": "\(userId)"]))
        }
    }
}

extension PlaceholderApi {
    public static func fetchUserByUserId(
        _ userId: Int,
        sabotage: Bool = false,
        completion: ((Result<ExampleUser?, CustomError>) -> Void)? = nil
    ) {
        let urlRequest = sabotage ? PlaceholderApi.error : PlaceholderApi.userByUserId(userId)
        
        URLSession.shared.dataTask(with: urlRequest.rawValue) { (data, _, err) in
            guard let data = data, err == nil else {
                completion?(Result.failure(CustomError.houstonWeHaveAProblem))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let users = try decoder.decode([ExampleUser].self, from: data)
                completion?(Result.success(users.first))
            } catch {
                completion?(Result.failure(CustomError.parsingWentWrong))
            }
        }.resume()
    }
}
