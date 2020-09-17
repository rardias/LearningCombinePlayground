//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Convenience publishers + subscribers
 
 - Note:
 Combine provides a number of additional convenience publishers and subscribers to get you started
 
 &nbsp;
 + **Future**\
 A publisher that eventually produces a single value and then finishes or fails. It is ideal for when you\
 want to make a single request, or get a single response, where the API you are using has a completion handler closure.
 
 \
 Especially useful to "wrap around" any asynchronous calls that use a single completion closure that you might already\
 have in your application. Even though it is obvious that network calls are great examples, there are many other uses:
 ```
 let futureAsyncPublisher = Future<Bool, Error> { promise in
     CNContactStore().requestAccess(for: .contacts) { grantedAccess, err in
         // err is an optional
         if let err = err {
             promise(.failure(err))
         }

         return promise(.success(grantedAccess))
     }
 }
 ```
 */
LogUtils.xmpl("Using `Future` publisher with async methods")

let fetchUserPublisher = PassthroughSubject<Int, CustomError>()
let cancellable = fetchUserPublisher
    .flatMap { userId -> Future<ExampleUser?, CustomError> in
        Future { promise in
            PlaceholderApi.fetchUserByUserId(userId, sabotage: false) { result in
                switch result {
                case .success(let user):
                    promise(.success(user))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    .replaceError(with: nil)
    .sink { result in
        guard let user = result else {
            LogUtils.warn("No user found!")
            return
        }
        
        LogUtils.info("Found user with name \(user.name!) and email \(user.email!)")
    }

DispatchQueue(label: "future").async {
    fetchUserPublisher.send(5)
}
//: [Next](@next)
