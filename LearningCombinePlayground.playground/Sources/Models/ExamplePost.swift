import Foundation

public struct ExamplePost: Codable {
    public var id: Int?
    public var userId: Int?
    public var title: String?
    public var body: String?
    
    public static var placeholder: ExamplePost {
        return ExamplePost(id: 0, userId: nil, title: "n/a", body: "n/a")
    }
    
    public static var badDummyData: Data? {
        return "----".data(using: .utf8)
    }
    
    public static var postDummyData: Data? {
        return "{\"userId\": 1, \"id\": 1, \"title\": \"sunt aut facere repellat provident occaecati excepturi optio reprehenderit\"}".data(using: .utf8)
    }
}
