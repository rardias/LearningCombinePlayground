//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Error handling operators
 
 - Note:
 How you handle the errors within a pipeline is dependent on how the pipeline is defined. If the\
 pipeline is set up to return a single result and terminate, a good example is `catch` to handle\
 errors in a one-shot pipeline. If the pipeline is set up to continually update, the error handling\
 needs to be a little more complex. In this case,`flatMap` might come to the rescue
 
 &nbsp;
 + **assertNoFailure**\
 Raises a fatal error when its upstream publisher fails, and otherwise republishes all received input and converts failure type to `<Never>`.
 
 &nbsp;
 + **replaceError**\
 A publisher that replaces any errors with an output value that matches the upstream Output type.
 
 &nbsp;
 + **catch**\
 The operator catch handles errors (completion messages of type .failure) from an upstream publisher by replacing\
 the failed publisher with another publisher. The catch operator also transforms the Failure type to `<Never>`.
 
 &nbsp;
 + **flatMap**\
 Used with error recovery or async operations that might fail (for example Future), `flatMap` will replace any incoming values with another publisher.
 
 _Given that in case of failure, the subscription to the upstream publisher is terminated. You provide a closure to `flatMap`_\
 _that can read in the value that was provided, and creates a one-shot publisher that does the possibly failing work._\
 _An example of this is requesting data from a network and then decoding the returned data._

 \
 _The completion from the created one-shot publishers terminates in the flatMap and is not passed to downstream subscribers._
*/
LogUtils.xmpl("Demonstrating simple error handling operators")
let postTitlePublisherOne = NotificationCenter.default.publisher(for: .newPost)
    .map { notif in
        return notif.object as! Data
    }
    .decode(type: ExamplePost?.self, decoder: JSONDecoder())
    // .assertNoFailure()
    // .catch { _ in
    //     return Just(nil)
    // }
    .replaceError(with: nil)

// Create subscriber for `NotificationCenter.publisher`
let cancellableOne = postTitlePublisherOne.sink { (post) in
    LogUtils.info(post?.title)
}

// Post dummy posts using `NotificationCenter`
NotificationCenter.default.post(name: .newPost, object: ExamplePost.badDummyData)
NotificationCenter.default.post(name: .newPost, object: ExamplePost.postDummyData)

LogUtils.xmpl("Demonstrating error handling operators using flatMap")
let postTitlePublisherTwo = NotificationCenter.default.publisher(for: .newPost)
    .map { notif in
        return notif.object as! Data
    }
    .flatMap { data in
        return Just(data)
            .decode(type: ExamplePost?.self, decoder: JSONDecoder())
            .catch { _ in return Just(nil)}
    }

// Subscribing a subject to the `NotificationCenter.publisher`
let postTitleSubject = PassthroughSubject<ExamplePost?, Never>()
postTitlePublisherTwo.subscribe(postTitleSubject)

// Create subscriber for `NotificationCenter.publisher`
let cancellableTwo = postTitleSubject.sink { (post) in
    LogUtils.info(post?.title)
}

// Post dummy posts using `NotificationCenter`
NotificationCenter.default.post(name: .newPost, object: ExamplePost.badDummyData)
NotificationCenter.default.post(name: .newPost, object: ExamplePost.postDummyData)

// Post dummy posts using subject
postTitleSubject.send(ExamplePost.placeholder)
postTitleSubject.send(nil)

// Cancel subscriber
cancellableTwo.cancel()

// Post dummy posts using `NotificationCenter` (will not be published)
NotificationCenter.default.post(name: .newPost, object: ExamplePost.postDummyData)
NotificationCenter.default.post(name: .newPost, object: ExamplePost.badDummyData)
