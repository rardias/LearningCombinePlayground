//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Timing control operators
 
 - Note:
 Combine allows the developers to handle "bursty" or extremely high-volume event streams where you\
 need to reduce the number of values delivered to the downstream to a rate you specify.
 
 &nbsp;
 + **delay**\
 Delays delivery of all output to the downstream receiver by a specified amount of time on a particular scheduler.
*/
LogUtils.xmpl("Delay operator")
let arrayPublisher = [10, 10, 20, 42, 33, nil, 11, 11, 40].publisher

let delaySubscriber = arrayPublisher
    .print()
    .compactMap { return $0 }
    .delay(for: 1.5, scheduler: RunLoop.main)
    .reduce("", { return "\($0) \($1)"})
    .sink { value in
        LogUtils.info("Suffered delay of 1.5 seconds: \(value)")
    }
/*:
 ---
 
 + **debounce**\
 `debounce collapses multiple values within a specified time window into a single value.\
 The operator will collapse any values received within the timeframe provided to a single, last value\
 received from the upstream publisher within the time window.
 
 
 \
 _This operator is frequently used with `removeDuplicates` when the publishing source is bound to UI interactions_\
 _primarily to prevent an "edit and revert" style of interaction from triggering unnecessary work._
*/
let relay = PassthroughSubject<Int, Never>()
let myTimer = MyTimer(relay)

var debounceSubscriber: AnyCancellable?
var throttleSubscriber: AnyCancellable?

DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
    LogUtils.xmpl("Debounce operator")
    myTimer.restartTimer()
    
    debounceSubscriber = relay
        .print()
        .debounce(for: 0.25, scheduler: RunLoop.main)
        .sink { value in
             LogUtils.info("Debounce: \(value)")
        }
}

DispatchQueue.main.asyncAfter(deadline: .now() + 9.5) {
    debounceSubscriber?.cancel()
    myTimer.stopTimer()
}
/*:
 ---
 
 + **throttle**\
 `throttle` constrains the stream to publishing zero or one value within a specified time window,\
 independent of the number of elements provided by the publisher.
 
 
 \
 _Throttle is akin to the `debounce` operator in that it collapses values. The primary difference is that debounce_\
 _will wait for no further values, where throttle will last for a specific time window and then publish a result._\
 _The value chosen within the time window is influenced by the parameter `latest`, a boolean indicating if the first_\
 _value or last value should be chosen._
*/
DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    LogUtils.xmpl("Throttle operator")
    myTimer.restartTimer()
    
    throttleSubscriber = relay
        .print()
        .throttle(for: 0.25, scheduler: RunLoop.main, latest: false)
        .sink { value in
             LogUtils.info("Throttle: \(value)")
        }
}

DispatchQueue.main.asyncAfter(deadline: .now() + 17.5) {
    throttleSubscriber?.cancel()
    myTimer.stopTimer()
}

//: [Next](@next)
