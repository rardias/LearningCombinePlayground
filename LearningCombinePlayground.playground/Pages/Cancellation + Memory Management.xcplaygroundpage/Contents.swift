//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Cancellation
 
 - Note:
 A subscription always returns a `AnyCancellable` object. Correct memory management makes sure you're
 not introducing memory leaks and retain cycles in your application. A subscription can be cancelled...
 \- when used on a deinitializing a class (view model, for example) that holds a reference to it
 \- explicitely, using `cancel()`
 
 &nbsp;
 **Example #1**\
 _Cancellation on class `deinit`_
*/
// Mocked queue of room sensor readings (7 total)
let roomMetricsQueue: [EnvironmentMetrics] = (0...6).map { _ in
    return EnvironmentMetrics.buildRandom()
}

// Initialization of the metrics relay (`PassthroughSubject`) for the
// publishing of the previous (mocked) sensor readings queue
let roomMetricsRelay = PassthroughSubject<EnvironmentMetrics, Never>()

let semaphore = DispatchSemaphore(value: 0)

LogUtils.xmpl("Cancellation on class `deinit`")

// Initialization of the `RoomSensorHandler` object
// NOTE: `RoomSensorHandler` stores publically the `AnyCancelable` subscription reference
var roomSensorHandler: RoomSensorHandler? = RoomSensorHandler(subject: roomMetricsRelay)

// Have `roomSensorHandler` process the sensor queue values
roomSensorHandler?.processSensorQueue(from: roomMetricsQueue, after: 0.5)

// Deinit `roomSensorHandler` after 2.0 seconds
DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
    LogUtils.warn("Will deinit roomSensorHandler object!")
    roomSensorHandler = nil
    semaphore.signal()
}

semaphore.wait()
/*:
 ---
 
 **Example #2**\
 _Cancellation using explicitely `AnyCancellable.cancel()`_
 */
LogUtils.xmpl("Cancellation using explicitely `AnyCancellable.cancel()`")

// Initialization of a new `RoomSensorHandler` object (same subject and mocked queue)
let roomSensorHandler2: RoomSensorHandler? = RoomSensorHandler(subject: roomMetricsRelay)

// Have `roomSensorHandler` process the sensor queue values
roomSensorHandler2?.processSensorQueue(from: roomMetricsQueue, after: 0.5)

// Deinit `roomSensorHandler` after 2.0 seconds
DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
    LogUtils.warn("Will explicitely cancel the established subscription!")
    roomSensorHandler2?.cancellable?.cancel()
    semaphore.signal()
}

semaphore.wait()

//: [Next](@next)
