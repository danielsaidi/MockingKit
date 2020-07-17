<h1>Mockery</h1>

<p align="center">
    <img src ="Resources/Logo.png" alt="Mockery Logo" /><br/>
    <a href="https://github.com/danielsaidi/Mockery">
        <img src="https://badge.fury.io/gh/danielsaidi%2FMockery.svg?style=flat" alt="Version" />
    </a>
    <img src="https://img.shields.io/badge/Swift-5.1-orange.svg" alt="Swift 5.0" />
    <img src="https://badges.frapsoft.com/os/mit/mit.svg?style=flat&v=102" alt="License" />
    <a href="https://twitter.com/danielsaidi">
        <img src="https://img.shields.io/badge/contact-@danielsaidi-blue.svg?style=flat" alt="Twitter: @danielsaidi" />
    </a>
</p>


## <a name="about"></a>About Mockery

Mockery is a mocking library for Swift. Mockery lets you `register` function results, `invoke` method calls and `inspect` invokations.

Example:

```swift
protocol Printer {
    func print(_ text: String)
}
 
// Inheriting `Mock`
class MockPrinter: Mock, Printer {

    lazy var printRef = MockReference(print)          // This has to be lazy

    func print(_ text: String) {
        invoke(printRef, arguments: (text))
    }
}

let printer = MockPrinter()
printer.print("Hello!")
let inv = printer.invokations(of: printer.printRef)    // => 1 item
inv[0].arguments.0                                     // => "Hello!"
printer.hasInvoked(printer.printRef)                   // => true
printer.hasInvoked(printer.printRef, numberOfTimes: 1) // => true
printer.hasInvoked(printer.printRef, numberOfTimes: 2) // => false
```

Mockery supports:

* synchronous and asynchronous functions.
* mocking functions with `void`, `optional` and `non-optional` results. 
* `values`, `structs`, `classes` and `enums`.

Mockery also doesn't put any restrains on your code or require you to structure it in any way. Just create a mock when you want to mock a protocol and you're good to go.


## <a name="installation"></a>Installation

### <a name="spm"></a>Swift Package Manager

```
https://github.com/danielsaidi/Mockery.git
```

### <a name="cocoapods"></a>CocoaPods

```ruby
pod 'Mockery'
```


## Demo App

This repository contains a demo app that demonstrates how to use Mockery. The unit tests are also thorough.

To run the demo project, just open and run `MockeryDemo.xcodeproj`.


## Creating a mock

Consider that you have the following protocol:

```swift
protocol TestProtocol {
    
    func functionWithIntResult(arg1: String, arg2: Int) -> Int
    func functionWithOptionalResult(arg1: String, arg2: Int) -> Int?
    func functionWithVoidResult(arg: String)
}
```

To create a mock of this protocol, just create a class that inherits `Mock` and implements `TestProtocol`:

```swift
class TestMock: Mock, TestProtocol {

    lazy var functionWithIntResultRef = MockReference(functionWithIntResult)
    lazy var functionWithOptionalResultRef = MockReference(functionWithOptionalResult)
    lazy var functionWithVoidResultRef = MockReference(functionWithVoidResult)
    
    func functionWithIntResult(arg1: String, arg2: Int) -> Int {
        invoke(functionWithIntResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalResult(arg1: String, arg2: Int) -> Int? {
        invoke(functionWithOptionalResultRef, args: (arg1, arg2))
    }
    
    func functionWithVoidResult(arg: String) {
        invoke(functionWithVoidResultRef, args: (arg))
    }
}
```

The mock will now record the function calls and return any pre-registered return values (or crash if you haven't registered any return values for non-optional functions).

If your mock must inherit another class (e.g. if you mock `UserDefaults`) and therefore can't inherit `Mock`, you can just let it implement `Mockable` instead and provide it with a custom `Mock` instance. The rest is identical to using `Mock`. `Mock` is actually just a `Mockable` that uses itself.


## Registering return values

If you mock a function that returns a value, you must register a value for the mock before calling the function in your tests. If you don't, Mockery will intentionally crash with a precondition failure.

You can register return values by calling `registerResult(for:)`:

```swift
let mock = TestMock()
mock.registerResult(for: mock.functionWithIntResultRef) { _ in return 123 }
```

The result block takes the same arguments as the actual function, so you can adjust the function logic depending on the input arguments.

You don't have to register a return value for optional result functions. However, non-optional functions will crash if you fail to register a result before calling them.


## Inspecting invokations

Use `invokations(of:)` to inspect a mock's performed invokations. An invokation reference contains information on how many times the function was executed, with which input arguments and the result:

```swift
_ = mock.functionWithResult(arg1: "abc", arg2: 123)
_ = mock.functionWithResult(arg1: "abc", arg2: 456)

let inv = mock.invokations(of: mock.functionWithIntResultRef)
expect(inv.count).to(equal(2))
expect(inv[0].arguments.0).to(equal("abc"))
expect(inv[0].arguments.1).to(equal(123))
expect(inv[1].arguments.0).to(equal("abc"))
expect(inv[1].arguments.1).to(equal(456))
```

The syntax above uses [Quick/Nimble][Quick], but you can naturally use any test framework you like.


## Registering and throwing errors

There is currently no support for registering and throwing errors, which means that async functions can't (yet) register custom return values.


## Contact me

Feel free to reach out if you have questions or if you want to contribute in any way:

* E-mail: [daniel.saidi@gmail.com][Email]
* Twitter: [@danielsaidi][Twitter]
* Web site: [danielsaidi.com][Website]


## Acknowledgements

Mockery is inspired by [Stubber][Stubber], and would not have been possible without it. However, Stubber uses global functions, which requires you to reset the global state every now and then. Mockery moves this logic to each mock, which means that any recorded exeuctions are automatically reset when the mock is disposed. Mockery also adds some extra functionality, like support for optional and void results and convenient inspection utilities.


## License

Mockery is available under the MIT license. See the [LICENSE][License] file for more info.


[Email]: mailto:daniel.saidi@gmail.com
[Twitter]: http://www.twitter.com/danielsaidi
[Website]: http://www.danielsaidi.com

[Carthage]: https://github.com/Carthage
[CocoaPods]: http://cocoapods.org
[GitHub]: https://github.com/danielsaidi/Mockery
[Pod]: http://cocoapods.org/pods/Mockery
[Quick]: https://github.com/Quick/Quick
[Stubber]: https://github.com/devxoul/Stubber
[License]: https://github.com/danielsaidi/Mockery/blob/master/LICENSE
