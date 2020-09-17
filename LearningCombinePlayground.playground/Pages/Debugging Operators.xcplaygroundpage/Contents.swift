//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Debugging operators
 
 - Note:
 Combine debugging can be hard with long stack traces which don’t help at all. Asynchronous callbacks\
 follow up on each other rapidly and easily make it hard to find the root cause of an issue.\
 Fortunately, there are some operators and tricks that improve the debugging experience in Xcode.
 
 &nbsp;
 + **handleEvents**\
 Using `handleEvents()` allows to specify closures for all events of a subscription lifecycle_
*/
LogUtils.xmpl("Using `handleEvents()` to display all stages of a subscription lifecycle")

let handleSubject = PassthroughSubject<String, CustomError>()

let handleSubscription = handleSubject
    .handleEvents(receiveSubscription: { subscription in
        LogUtils.info("New subscription: \(subscription.combineIdentifier)!")
    },receiveOutput: { _ in
        LogUtils.info("Subscription received value!")
    },receiveCompletion: { _ in
        LogUtils.info("Subscription completed!")
    },receiveCancel: {
        LogUtils.warn("Subscription cancelled!")
    }, receiveRequest: { demand in
        LogUtils.info("Subscription demand: \(demand)")
    })
    .replaceError(with: "Oops! We've got a problem!")
    .sink { _ in }

handleSubject.send("Hello World!")
handleSubscription.cancel()
/*:
 ---
 
 + **print**\
 Prints log messages for all publishing events.
 */
LogUtils.xmpl("Using `print(_:)` to log messages for every event")

let printSubscription = handleSubject
    .print("printSubscription log")
    .replaceError(with: "Oops! We've got a problem!")
    .sink { _ in }

handleSubject.send("Hello World!")
printSubscription.cancel()
/*:
 ---
 
 + **breakpoint/breakpointOnError**\
 The `breakpoint` operator raises a debugger signal when a provided closure identifies the\
 need to stop the process in the debugger. `breakpointOnError` is a specialization upon receiving a failure
 */
LogUtils.xmpl("Using `breakpoint(_:)` to trigger the debugger stack trace on specific values")
print("Unable to raise a debugger signal in Xcode Playgrounds...")

let breakSubscription = handleSubject
    .breakpointOnError()
    .breakpoint(receiveOutput: { $0 == "Break!" })

handleSubject.send("Break!")
handleSubject.send(completion: .failure(.houstonWeHaveAProblem))

//: [Next](@next)
