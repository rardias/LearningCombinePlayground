import Foundation

// Environment metrics struct
public class EnvironmentMetrics {
    public var humidity: Int
    public var temperature: Int
    
    public init(humidity: Int, temperature: Int) {
        self.humidity = humidity
        self.temperature = temperature
    }
    
    public static func buildRandom() -> EnvironmentMetrics {
        let humidity = Int.random(in: 40...45)
        let temperature = Int.random(in: 22...28)
        
        return EnvironmentMetrics(humidity: humidity, temperature: temperature)
    }
}
