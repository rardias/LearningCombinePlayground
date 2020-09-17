//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Convenience publishers + subscribers
 
 - Note:
 Combine provides a number of additional convenience publishers and subscribers to get you started
 
 &nbsp;
 ### Convenience subscribers
 + **Assign**\
 Applies values passed down from the publisher to an object defined by a keypath.
 */
LogUtils.xmpl("Simple usage of `Assign` Subscriber")
let arrayPublisher = [1,2,3,4,5].publisher

class DummyClass {
    var dummyProperty: Int = 0 {
        didSet {
            LogUtils.info("Did set property to: \(dummyProperty)")
        }
    }
}

let dummyObj = DummyClass()
arrayPublisher.assign(to: \.dummyProperty, on: dummyObj)

/*:
 + **Sink**\
 Accepts a closure that receives any resulting values from the publisher. This allows\
 the developer to terminate the stream with their own code.
 */
 LogUtils.xmpl("Simple usage of `Sink` Subscriber")

 arrayPublisher.sink { value in
     LogUtils.info("Received value from arrayPublisher: \(value)")
 }

//: [Next](@next)
