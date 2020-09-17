import Foundation

/*:
 ## Foundation asynchronous interfaces

 **Notification Center**\
 _(A notification dispatch mechanism that enables the broadcast of information to registered observer)_
 */
LogUtils.xmpl("Notification Center")

extension Notification.Name {
    static let myNotificationName: Notification.Name =
    Notification.Name("myNotification")
}

NotificationCenter.default.addObserver(
    forName: .myNotificationName,
    object: nil,
    queue: .main
) { _ in
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
LogUtils.info("My name is \(me.name!)")

me.observe(\Person.name, options: .new) { person, change in
    let message = "I've updated my name to \(person.name!)"
    LogUtils.info(message)
}

me.name = "Ricardo Ramos Dias"
/*:
 ---
 
 **Ad-hoc callbacks**\
 _(Closures / completion blocks)_
 */
LogUtils.xmpl("Ad-hoc callbacks")

func power(_ value: Int, completion: (Int) -> Void) {
    completion(value * value)
}

let inValue = 5
power(inValue) { result in
    let message = "The power of \(inValue) is \(result)"
    LogUtils.info(message)
}
/*:
 ---

 **URLSession**\
 _(Native network interface for handling network calls)_
 */
URLSession.shared.dataTask(with: PlaceholderApi.users.rawValue) { (data, _, error) in
    LogUtils.xmpl("URLSession")
    LogUtils.info("Request data: \(String(describing: data))")
    LogUtils.info("Request error: \(error?.localizedDescription ?? "n/a")")
}.resume()
/*:
 ---

 **Timers**
 */
Thread.sleep(forTimeInterval: 2.0)
LogUtils.xmpl("Timers")

var runCount = 0
Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
    if runCount == 2 { timer.invalidate() }
    
    LogUtils.info("Timer fired!")
    runCount += 1
}

//: [Next](@next)
