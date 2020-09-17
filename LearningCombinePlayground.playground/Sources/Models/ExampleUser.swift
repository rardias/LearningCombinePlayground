import Foundation

public struct ExampleUser: Codable {
    public var id: Int?
    public var email: String?
    public var name: String?
    public var username: String?
    public var posts: [ExamplePost]?
}
