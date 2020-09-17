//: [Previous](@previous)

/*:
 ## What is Apple Combine?
 - Note:
 Combine is a unified declarative API for processing values over time.
 
 &nbsp;
 ### Combine Pattern

 _**Combine** declares **publishers** to expose values that can change over time, and **subscribers** to receive those values from the publishers._
 
 The _Combine_ pattern could be represented with this sequence diagram:
 
 ![Combine pattern  diagram](combine_pattern_diagram.png)

 1. `Subscriber` is attached to `Publisher`
 2. `Publisher` sends a `Subscription`
 3. `Subscriber` requests _N_ values
 4. `Publisher` sends _N_ values or less
 5. `Publisher` sends completion
 */

//: [Next](@next)
