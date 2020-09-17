import Foundation

public extension Notification.Name {
    static let humidityChanged = Notification.Name(rawValue: "humidityChanged")
    static let temperatureChanged = Notification.Name(rawValue: "temperatureChanged")
    
    static let newPost = Notification.Name(rawValue: "newPost")
}
