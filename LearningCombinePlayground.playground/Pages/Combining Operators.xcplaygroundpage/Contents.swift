//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Combining operators
 
 - Note:
 Combine allows the developers to mix elements from multiple publishers
 
 &nbsp;
 + **merge**\
 Merge takes two upstream publishers and mixes the elements published into a single pipeline as they are received.\
 In order to merge this upstream publishers, they must have the same output and failure types.
 
 \
 _To merge more that two upstream publishers, Combine also provides `merge3`, `merge4`, and so on until `merge8`._\
 _If merging of more than 8 upstream publishers are required, you can combine with upstream `merge` operators._
*/
LogUtils.xmpl("Demonstrating merge")
let publisher1 = [1,2,3,4,5].publisher
let publisher2 = [10,20,30,40,50].publisher

let mergedSubscription = Publishers
    .Merge(publisher1, publisher2)
    .sink { value in
        LogUtils.info("Merge: Received value \(value)")
    }
/*:
 ---
 
 + **combineLatest**\
 Merges two pipelines into a single output, converting the output type to a tuple of values from the\
 upstream pipelines, and providing an update when any of the upstream publishers provide a new value.\
 All upstream publishers must have the same failure type.
 
 \
 _To merge more that two upstream publishers, Combine also provides `combineLatest3` and `combineLatest4`_\
 _If merging of more than 4 upstream publishers are required, you can combine with upstream `combineLatest` operators._
*/
let semaphore = DispatchSemaphore(value: 0)
LogUtils.xmpl("Demonstrating combineLatest")
// **Simulated** input on app registration form
let usernamePublisher = PassthroughSubject<String, Never>()
let passwordPublisher = PassthroughSubject<String, Never>()
let confPasswordPublisher = PassthroughSubject<String, Never>()

// **Combine** the latest value of each input to check validity
let validatedCredentialsSubscription = Publishers
    .CombineLatest3(usernamePublisher, passwordPublisher, confPasswordPublisher)
    .map { (username, password, confPassword) -> Bool in
        !username.isEmpty &&
        (password == confPassword) &&
        (!password.isEmpty && password.count > 8)
        
    }
    .sink { valid in
        print("CombineLatest: Are credentials valid? \(valid ? "Yes" : "No")!")
    }

// Simulate input
usernamePublisher.send("ricardo")
passwordPublisher.send("")
confPasswordPublisher.send("")

DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
    passwordPublisher.send("weakpass")
    confPasswordPublisher.send("weakpas")
}

DispatchQueue.global().asyncAfter(deadline: .now() + 2.5) {
    passwordPublisher.send("verystrongpassword")
    confPasswordPublisher.send("verystrongpassword")
    semaphore.signal()
}

semaphore.wait()
/*:
 ---
 
 + **zip**\
 Takes two upstream publishers and mixes the elements published into a single pipeline, waiting until\
 values are paired up from each upstream publisher before forwarding the pair as a tuple.\
 All upstream publishers must have the same failure type.
 
 \
 The notable difference from `combineLatest` is that zip waits for values to arrive from the upstream publishers,\
 and will only publish a single new tuple when new values have been provided from all upstream publishers.
 
 \
 _To mix more that two upstream publishers, Combine also provides `zip3` and `zip4`_\
 _If mixing of more than 4 upstream publishers are required, you can combine with upstream `zip` operators._
*/
LogUtils.xmpl("Demonstrating Zip")
// **Simulated** status of several network requests
let profileCompletedPublisher = PassthroughSubject<Bool, Never>()
let termsAcceptedPublisher = PassthroughSubject<Bool, Never>()

// **Combine** the latest value of each input to check validity
let continueSubscription = Publishers
    .Zip(profileCompletedPublisher, termsAcceptedPublisher)
    .map { (profileCompleted, termsAccepted) -> Bool in
        profileCompleted && termsAccepted
    }
    .sink { result in
        print("Zip: Continue to Home screen? \(result ? "Yes" : "No")!")
    }

// Simulate status
DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
    profileCompletedPublisher.send(true)
}

DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
    profileCompletedPublisher.send(true)
}

DispatchQueue.global().asyncAfter(deadline: .now() + 2.5) {
    termsAcceptedPublisher.send(true)
    semaphore.signal()
}

//: [Next](@next)
