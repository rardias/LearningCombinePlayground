import Combine
import Foundation

public class RoomSensorHandler {
    public var cancellable: AnyCancellable?
    public var subject: PassthroughSubject<EnvironmentMetrics,Never>?
    
    public var roomMetrics: EnvironmentMetrics? {
        didSet {
            LogUtils.info("Current Humidity: \(roomMetrics!.humidity) | Current temperature: \(roomMetrics!.temperature)")
        }
    }

    public init(subject: PassthroughSubject<EnvironmentMetrics,Never>) {
        self.subject = subject
        self.cancellable = subject.handleEvents(receiveCompletion: { _ in
            LogUtils.warn("Subscription completed!")
        }, receiveCancel: {
            LogUtils.warn("Subscription cancelled!")
        }).sink { _ in
            // Introducing a retain cycle on `self`on purpose, by not using `weak` or `unowned`
            LogUtils.info("New sensor update!")
        }
    }

    deinit {
        LogUtils.warn("RoomSensorHandler object deallocated!")
    }
    
    public func processSensorQueue(from values: [EnvironmentMetrics], after delay: TimeInterval) {
        guard let subject = subject else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            var sensorArray = values
            subject.send(sensorArray.removeFirst())
            if !sensorArray.isEmpty {
                self?.processSensorQueue(from: sensorArray, after: delay)
            } else {
                subject.send(completion: .finished)
            }
        }
    }
}
