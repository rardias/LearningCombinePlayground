//: [Previous](@previous)

import Combine
import Foundation

/*:
 ## Key Concepts
 
 - Note:
 A Publisher _publishes_ values ...\
 ... a subscriber _subscribes_ to receive publisher's values
 
 &nbsp;
 ### Publisher
 + Value type (Struct)
 + Describes how values and/or error are produced
 + Allows registration of a subscriber
 
 &nbsp;
 ### Subscriber
 + Reference type (Class)
 + Requests and accepts values over time and possibly a completion
 
 &nbsp;
 ### Operator
 + Adopts **Publisher** (therefore, also value type)
 + Describes a behaviour for changing values
 + Subscribes to a publisher (_"upstream"_)
 + Sends the result to a subscriber (_"downstream"_)
 */

/*:
 **Example #1**\
 _`NotificationCenter` Publisher + `Assign` Subscriber using  (not working?)_
 */
LogUtils.xmpl("`NotificationCenter` Publisher + `Assign` Subscriber using (FAIL)")

// Initialize the room metrics with default values
let roomMetrics = EnvironmentMetrics.buildRandom()
LogUtils.info("Initial humidity: \(roomMetrics.humidity)%")
LogUtils.info("Initial temperature: \(roomMetrics.temperature)ºC")

// Need create a publisher that notifies when temperature
// changes (using `NotificationCenter`)
let temperaturePublisher = NotificationCenter.Publisher(
    center: .default,
    name: .temperatureChanged,
    object: nil
)

// Now, need a subscriber to request and process the
// temperature values returned by the publisher
let temperatureSubscriber = Subscribers.Assign(object: roomMetrics, keyPath: \.temperature)

// Finally, establish the subscription
// temperaturePublisher.subscribe(temperatureSubscriber)
/*:
 - Important:
 However, as expected, when the subscription between publisher and
 subscriber is being established, it returns an error, because Input (`Notification`)
 does not match Output (`Int`). Hence the commented line.
 
 ---
 
 **Example #2**\
 _`NotificationCenter` Publisher + `Map` Operator + `Assign` Subscriber`_
 */
LogUtils.xmpl("NotificationCenter` Publisher + `Map` Operator + `Assign` Subscriber")

// Using the pre-existing publisher and subscriber, let's introduce
// an operator that allows us to match the Input and Output types
let temperatureConverter = Publishers.Map(upstream: temperaturePublisher) { notif -> Int in
    guard let metrics = notif.object as? EnvironmentMetrics else {
        return 0
    }
    
    return metrics.temperature
}

// Establish the subscription between publisher and subscriber
temperatureConverter.subscribe(temperatureSubscriber)

// Read the data from sensors and publish the new updated information
Thread.sleep(forTimeInterval: 1.0)
let newRoomMetrics = EnvironmentMetrics.buildRandom()
temperaturePublisher.center.post(name: .temperatureChanged, object: newRoomMetrics)
LogUtils.info("Current temperature: \(roomMetrics.temperature)ºC")
/*:
 ---
 
 **Example #3**\
 _NotificationCenter` Publisher + `Map` Operator + `Assign` Subscriber (Fluent Syntax)_
 */
LogUtils.xmpl("NotificationCenter` Publisher + `Map` Operator + `Assign` Subscriber (Fluent Syntax)")

// This time, created publisher and subscriber for the humidity metric
let humiditySubscriber = NotificationCenter.default
    // Delare the publisher for the `humidityChanged` event
    .publisher(for: .humidityChanged)
    // Map the Output of the publisher to the Input of the subscriber using `map`
    .map { notif -> Int in
        guard let metrics = notif.object as? EnvironmentMetrics else {
            return 0
        }
        
        return metrics.humidity
    }
    // Assign the published (and transformed) value to the specific property
    .assign(to: \.humidity, on: roomMetrics)


// Read the data from sensors and publish the new updated information
// NOTE: Simulated various sensor readings with random values
for _ in 0...2 {
    Thread.sleep(forTimeInterval: 1.0)
    let newRoomMetrics2 = EnvironmentMetrics.buildRandom()
    NotificationCenter.default.post(name: .humidityChanged, object: newRoomMetrics2)
    LogUtils.info("Current humidity: \(roomMetrics.humidity)%")
}
//: [Next](@next)
