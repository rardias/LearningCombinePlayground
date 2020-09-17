//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Common Operators
 
 - Note:
 While the number of built-in operators can be quite intimidating, quite a few should\
 not be new to developers used to working with collections (Arrays, sequences). Some of\
 the operators commonly used there are now available assynchronously to use with Combine pipelines.
 
 \
 This is still a work in progress, and for now, I created examples for the most common operators, in my opinion.
 And remember, with Combine remember: **Try composition first**.
*/
// Sequence publisher
let arrayPublisher = [10, 10, 20, 42, 33, nil, 11, 11, 40].publisher

// Just a subscription of the publisher with no operators envolved
LogUtils.xmpl("Original sequence of values")
let origSubscriber = arrayPublisher
    .sink { value in
        LogUtils.info("Original value: \(String(describing: value))")
    }
/*:
 **map**\
 Commonly used to convert one data type into another along a pipeline.
 
 \
 **compactMap**\
 Calls a closure with each received element and publishes any returned optional that has a value.\
 In other words, removes null values from the pipeline.
*/
LogUtils.xmpl("map (+ compactMap)")
let mapSubscriber = arrayPublisher
    .compactMap { return $0 }
    .map { Double($0).squareRoot() }
    .sink { value in
        LogUtils.info("Square root value: \(value)")
    }
/*:
 ---
 
 **removeDuplicates**\
 Remembers what was previously sent in the pipeline, and only passes forward values that don’t match the current value.\
 Does not remove duplicates in all the sequence of values, only consecutive ones.
*/
LogUtils.xmpl("removeDuplicates")
let remDuplicatesSubscriber = arrayPublisher
    .compactMap { return $0 }
    .removeDuplicates()
    .sink { value in
        LogUtils.info("Unique value: \(value)")
    }
/*:
 ---
 
 **max**\
 Publishes the max value of all values received _upon completion_ of the upstream publisher.
 
 \
 **replaceNil**
 Replaces nil elements in the stream with the provided element.
*/
LogUtils.xmpl("max (+ replaceNil)")
let maxSubscriber = arrayPublisher
    .replaceNil(with: -1)
    .max()
    .sink { value in
        LogUtils.info("Max value: \(value)")
    }
/*:
 ---
 
 **min**\
 Publishes the minimum value of all values received _upon completion_ of the upstream publisher.
*/
LogUtils.xmpl("min (+ replaceNil)")
let minSubscriber = arrayPublisher
    // .compactMap { return $0 }
    .replaceNil(with: -1)
    .min()
    .sink { value in
        LogUtils.info("Min value: \(value)")
    }
/*:
 ---
 
 **drop**\
 A publisher that omits a specified number of elements before republishing later elements.
 
 \
 **reduce**\
 A publisher that applies a closure to all received elements and produces an accumulated value when the upstream publisher finishes.
*/
LogUtils.xmpl("dropFirst (+ reduce)")
let dropSubscriber = arrayPublisher
    .compactMap { return $0 }
    .dropFirst(2)
    .reduce("", { return "\($0) \($1)"})
    .sink { value in
        LogUtils.info("Remaining after drop: \(value)")
    }
/*:
 ---
 
 **first**\
 A publisher that only publishes the first element of a stream to satisfy a predicate closure.
*/
LogUtils.xmpl("first")
let firstSubscriber = arrayPublisher
    .compactMap { return $0 }
    .first(where: { $0 > 20})
    .sink { value in
        LogUtils.info("First value (>20): \(value)")
    }
/*:
 ---
 
 **filter**\
 Passes through all instances of the output type that match a provided closure, dropping any that don’t match.
*/
LogUtils.xmpl("filter")
let filterSubscriber = arrayPublisher
    .compactMap { return $0 }
    .filter { $0 > 11 }
    .reduce("", { return "\($0) \($1)"})
    .sink { value in
        LogUtils.info("Values > 11: \(value)")
    }

//: [Next](@next)
