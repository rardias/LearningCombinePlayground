//: [Previous](@previous)

import Combine
import Foundation
import PlaygroundSupport
import UIKit

/*:
 # Convenience publishers + subscribers
 - Note:
 Combine provides a number of additional convenience publishers and subscribers to get you started

 &nbsp;
 + **@Published**\
 A property wrapper that adds a Combine publisher to any property. It triggers data updates whenever the\
 property is changed.Even though highly associated with SwiftUI, we are also able to use it with UIKit.
*/
class FormViewModel {
    @Published var isSubmitAllowed: Bool = true
}
/*:
 ---

 + **ObservableObject**\
 When a class includes a `@Published` property and conforms to the `ObservableObject` protocol,\
 this class instances will provide a `objectWillChange` publisher . The publisher will not\
 return any of the changed data, only an indicator that the referenced object has changed.
 
 \
 As a note, only properties using the `@Published` wrapper trigger `objectWillChange`.
*/
class ObservableFormViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    var age: Int = 30
}
/*:
 ---

 Also, a quick reminder that like other FRP frameworks, Combine also enhances the ability to develop\
 your apps with more "cleaner" and "robust" architectures, like MVVM or others. Segmenting the code\
 in smaller pieces, but being able to combine them in complex pipelines to build complex features.
*/
class FormViewController: UIViewController {

    var formViewModel: FormViewModel?
    var observableViewModel: ObservableFormViewModel?
    let submitButton = UIButton()
    
    var publishedCancellable: AnyCancellable?
    var observableCancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe to a @Published property using the $ wrapped accessor
        self.formViewModel = FormViewModel()
        self.publishedCancellable = formViewModel?.$isSubmitAllowed
            .receive(on: DispatchQueue.main)
            .print()
            .assign(to: \.isEnabled, on: submitButton)
        
        // Subscribe to an `ObservableObject`, (fires for every @Published property)
        
        self.observableViewModel = ObservableFormViewModel()
        self.observableCancellable = observableViewModel?
            .objectWillChange
            .receive(on: DispatchQueue.main)
            .sink{ _ in
                LogUtils.warn("Form changed: \"\(self.observableViewModel!.username)\" ||  \"\(self.observableViewModel!.password)\"")
            }

    }
    
    override func loadView() {
        let myView = UIView()
        myView.backgroundColor = .black
        
        let label = UILabel()
        label.textColor = .white
        label.text = "Testing @Published and ObservableObject publishers"
        label.translatesAutoresizingMaskIntoConstraints = false
        myView.addSubview(label)
        
        let constraints = [
            label.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: myView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 30)
        ]

        NSLayoutConstraint.activate(constraints)
        self.view = myView
    }
}

// In order to see it working using UIKit (UIViewController, in this case)
// in Xcode playgrounds, it is required do populate its liveView
let formViewController = FormViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = formViewController

DispatchQueue(label: "published").async {
    LogUtils.xmpl("Using `@Published` properties")
    formViewController.formViewModel?.isSubmitAllowed = false
}

DispatchQueue(label: "observableObject").asyncAfter(deadline: .now() + 1.5) {
    LogUtils.xmpl("Using `ObservableObject`")
    formViewController.observableViewModel?.username = "Ricardo"
    formViewController.observableViewModel?.password = "123456"
    formViewController.observableViewModel?.age = 34
}
//: [Next](@next)
