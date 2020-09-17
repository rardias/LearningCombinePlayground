//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Convenience publishers + subscribers
 
 - Note:
 Combine provides a number of additional convenience publishers and subscribers to get you started
 
 &nbsp;
 ### Convenience publishers
 + **Sequence**\
 Provides a way to return values as subscribers demand them initialized from a collection. Formally,\
 it provides elements from any type conforming to the sequence protocol (Ex: `Array`).
 */
LogUtils.xmpl("A collection of elements provided by publisher `Sequence`")
(0..<5).publisher
    .reduce(0, { $0 + $1 })
    .sink { value in
        LogUtils.info("The sum of every integer in the collection is \(value)")
    }
/*:
 ---
 
 + **Just**\
 Provides a single result and then terminates, providing a publisher with a failure type of `Never`.\
 Also, often used within a closure to `flatMap` in error handling, it creates a single-response stream
 for use in error handling of continuous values (`Publisher.Catch`).
 */
LogUtils.xmpl("A simple single result publisher (`Just`)")

Just(42).sink { value in
 LogUtils.info("The Almighty Answer to the Meaning of Life, the Universe, and Everything is \(value)")
}

let semaphore = DispatchSemaphore(value: 0)
LogUtils.xmpl("Using `Just` in error handling")

let justDataTask = URLSession.shared.dataTaskPublisher(for: PlaceholderApi.error.rawValue)
    .map { $0.data }
    .decode(type: [ExampleUser].self, decoder: JSONDecoder())
    .catch { err -> Just<[ExampleUser]> in
        LogUtils.err(err.localizedDescription)
        LogUtils.warn("Returning empty array")
        return Just([])
    }
    .eraseToAnyPublisher()
    .sink { users in
        LogUtils.info("Retrieved \(users.count) user(s)")
        semaphore.signal()
    }

semaphore.wait()
/*:
 ---
 
 + **Fail**\
 A publisher that immediately terminates with the specified error.
 */
LogUtils.xmpl("Using `Fail` in error handling")
let failDataTask = URLSession.shared.dataTaskPublisher(for: PlaceholderApi.error.rawValue)
    .map { $0.data }
    .decode(type: [ExampleUser].self, decoder: JSONDecoder())
    .catch { err -> Fail<[ExampleUser], Error> in
        return Fail<[ExampleUser], Error>(error: CustomError.houstonWeHaveAProblem)
    }
    .eraseToAnyPublisher()
    .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
            LogUtils.err(error.localizedDescription)
            semaphore.signal()
        case .finished:
            LogUtils.info("Subscription cancelled!")
            semaphore.signal()
        }
    }, receiveValue: { users in
        LogUtils.info("Retrieved \(users.count) user(s)")
    })

semaphore.wait()

//: [Next](@next)
