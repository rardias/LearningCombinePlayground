//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Subscription
 
 - Note:
 A subscriber will receive a _single_ subscription where...
 \- _zero_ or _more_ values can be published
 \- at most _one_ {completion, error} will be called
 \- after completion, no more values are received
 
 &nbsp;
 **Example #1**\
 _Using `handleEvents()` to display all stages of a subscription lifecycle_
*/
LogUtils.xmpl("Using `handleEvents()` to display all stages of a subscription lifecycle")

let helloSubject = PassthroughSubject<String, CustomError>()

helloSubject
    .handleEvents(receiveSubscription: { subscription in
        LogUtils.info("New subscription: \(subscription.combineIdentifier)!")
    },receiveOutput: { _ in
        LogUtils.info("Subscription received value!")
    },receiveCompletion: { completion in
        switch completion {
        case .failure:
            LogUtils.err("Oops! We've got a problem!")
        case .finished:
            LogUtils.info("Subscription completed!")
        }
    },receiveCancel: {
        LogUtils.warn("Subscription cancelled!")
    })
    .assertNoFailure()
    .sink { value in
        LogUtils.info("> \(value)")
    }

helloSubject.send("Hello World!")
helloSubject.send("Are you there?")
helloSubject.send("Nice to meet you as well...")
helloSubject.send("Goodbye.")
// helloSubject.send(completion: .failure(.houstonWeHaveAProblem))
helloSubject.send(completion: .finished)

/*:
 ---
 **Example #2**\
 _Using `handleEvents()` to intercept all stages of a subscription lifecycle #2_
 
 \
 This time, using `replaceError` to prevent failure on said event...
 */
LogUtils.xmpl("Using `handleEvents()` to intercept all stages of a subscription lifecycle #2")

let otherHelloSubject = PassthroughSubject<String, CustomError>()

otherHelloSubject
    .replaceError(with: "Oops! We've got a problem!")
    .handleEvents(receiveSubscription: { subscription in
        LogUtils.info("New subscription: \(subscription.combineIdentifier)!")
    },receiveOutput: { _ in
        LogUtils.info("Subscription received value!")
    },receiveCompletion: { _ in
        LogUtils.info("Subscription completed!")
    },receiveCancel: {
        LogUtils.warn("Subscription cancelled!")
    })
    .sink { value in
        LogUtils.info("> \(value)")
    }

otherHelloSubject.send("Hello World!")
otherHelloSubject.send("It's me again.")
otherHelloSubject.send("Something is not right...")
otherHelloSubject.send(completion: .failure(.houstonWeHaveAProblem))
otherHelloSubject.send("Can you still ear me?")
otherHelloSubject.send(completion: .finished)

//: [Next](@next)
