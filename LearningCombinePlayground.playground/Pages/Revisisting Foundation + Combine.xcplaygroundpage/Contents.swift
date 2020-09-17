//: [Previous](@previous)

import Foundation

/*:
 ## Foundation + Combine

 **Notification Center**\
 _(A notification dispatch mechanism that enables the broadcast of information to registered observer)_
 */
LogUtils.xmpl("Notification Center")

extension Notification.Name {
    static let myNotificationName: Notification.Name =
    Notification.Name("myNotification")
}

NotificationCenter.default.publisher(for: .myNotificationName)
    .sink { notif in
        let message = "I've observed a notification!"
        LogUtils.info(message)
    }

NotificationCenter.default.post(name: .myNotificationName, object: nil)
/*:
 ---
 
 **Key-Value Observing**\
 _(Pattern in which objects can observe and be notified about changes to the properties of other objects)_
 */
LogUtils.xmpl("Key-Value Observing")

@objc class Person: NSObject {
    @objc dynamic var name: String?

    init(_ name: String) {
        self.name = name
    }
}

let me = Person("Ricardo Dias")

me.publisher(for: \.name)
    .sink { newName in
        let message = "I've updated my name to \(newName!)"
        LogUtils.info(message)
    }

me.name = "Ricardo Ramos Dias"
/*:
 ---
 
 **Ad-hoc callbacks**\
 _(Closures / completion blocks)_
 */
LogUtils.xmpl("Ad-hoc callbacks")

func power(_ value: Int) -> Int {
    return value * value
}

let inValue = 5
Result<Int, Never>.Publisher(.success(power(inValue)))
    .sink { result in
        let message = "The power of \(inValue) is \(result)"
        LogUtils.info(message)
    }
/*:
 ---
 
 **URLSession**\
 _(Native network interface for handling network calls)_
 */
URLSession.shared.dataTaskPublisher(for: PlaceholderApi.users.rawValue)
    .map { $0.data }
    .sink(receiveCompletion: { result in
        switch result {
        case .failure(let error):
            LogUtils.xmpl("URLSession")
            LogUtils.info("Request error: \(error.localizedDescription)")
        default:
            break
        }
    }, receiveValue: { data in
        LogUtils.xmpl("URLSession")
        LogUtils.info("Request data: \(String(describing: data))")
    })
/*:
 ---
 
 **Timers**
 */
Thread.sleep(forTimeInterval: 2.0)
LogUtils.xmpl("Timers")

let timer = Timer.publish(every: 1.0, on: .main, in: .default)
    .autoconnect()
    .sink { timer in
        LogUtils.info("Timer fired!")
    }

DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
    timer.cancel()
}

//: [Next](@next)
