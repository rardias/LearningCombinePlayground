//: [Previous](@previous)

import Combine
import Foundation

/*:
 # Subjects
 
 - Note:
 A subject is a special case of publisher ...\
 \- can manually "inject" new values into a stream using `send(_:)`\
 \- can relay values it receives from other publishers
 
 &nbsp;
 **Example #1**\
 _Inject values into a stream [`PassthroughSubject`]_
*/
LogUtils.xmpl("Inject values into a stream [`PassthroughSubject`]")
let temperatureRelay = PassthroughSubject<Int, Never>()

temperatureRelay.sink { newTemp in
    LogUtils.info("[temperatureRelay] New temperature: \(newTemp)ºC")
}

temperatureRelay.send(23)
temperatureRelay.send(25)
temperatureRelay.send(24)
/*:
 ---
 
 **Example #2**\
 _Subscribing a subject to a publisher_
 */
LogUtils.xmpl("Subscribing a subject to a publisher")

let newTempPublisher = (28...32).publisher
newTempPublisher.subscribe(temperatureRelay)

/*:
 ---
 
 **Example #3**\
 _Inject values into a stream [`CurrentValueSubject`]_
 */
// Contrary to `PassthroughSubject`, `CurrentValueSubject` stores
// an initial value passed to a new subscriber when establishing subscription
LogUtils.xmpl("Inject values into a stream [`CurrentValueSubject`]")

let currentHumidity = CurrentValueSubject<Int, Never>(40)
currentHumidity.sink { newHumid in
    LogUtils.info("[currentHumidity] New value: \(newHumid)ºC")
}


currentHumidity.send(43)
currentHumidity.send(41)
currentHumidity.send(42)

//: [Next](@next)
