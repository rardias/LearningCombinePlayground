import Combine
import Foundation

public class MyTimer {
    var relay: PassthroughSubject<Int, Never>?
    var timer: Timer?
    
    
    public init(_ relay: PassthroughSubject<Int, Never>) {
        self.relay = relay
    }
    
    public func restartTimer() {
        let random = Double.random(in: 0.05...0.45)
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(random), repeats: false) { _ in
            let value = Int.random(in: 18...27)
            self.relay?.send(value)
            
            self.restartTimer()
        }
    }

    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
