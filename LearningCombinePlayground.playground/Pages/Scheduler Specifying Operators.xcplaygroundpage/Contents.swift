//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Scheduler Specifying operators
 
 - Note:
 Combine allows for publishers to specify the scheduler used when either receiving from an upstream publisher\
 (in the case of operators), or when sending to a downstream subscriber. This is critical when working with a\
 subscriber that updates UI elements, as that should always be called on the main thread.
 
 &nbsp;
 + **subscribe(on:)**\
 Defines the scheduler on which to run a publisher in a pipeline.
 
 &nbsp;
 + **receive(on:)**\
 Defines the scheduler on which to receive elements from the publisher.
*/
LogUtils.xmpl("Demonstrating scheduling and threading operators")
let upstreamScheduler = DispatchQueue(label: "upstream")
let downstreamScheduler = DispatchQueue(label: "downstream")

// validate
let cancellable = Just<Int>(0)
  .subscribe(on: upstreamScheduler)
  .map({ _ in
    let name = __dispatch_queue_get_label(nil)
    LogUtils.warn("SubscribeOn: \(String(cString: name, encoding: .utf8))")
  })
  .receive(on: downstreamScheduler)
  .sink(receiveValue: { _ in
    let name = __dispatch_queue_get_label(nil)
    LogUtils.warn("ReceiveOn: \(String(cString: name, encoding: .utf8))")
})

//: [Next](@next)
