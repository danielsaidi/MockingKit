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

Mockery is a mocking library for Swift. Mockery lets you `invoke` method calls, `register` function results and `inspect` function invokations.

Example:

```swift
protocol Printer {
    func print(_ text: String)
}
 
// Inheriting `Mock`
class MockPrinter: Mock, Printer {
    func print(_ text: String) {
        invoke(print, arguments: (text))
    }
}

let printer = MockPrinter()
printer.print("Hello!")
let inv = printer.invokations(of: printer.print)    // => 1 item
inv[0].arguments.0                                  // => "Hello!"
printer.hasInvoked(printer.print)                   // => true
printer.hasInvoked(printer.print, numberOfTimes: 1) // => true
printer.hasInvoked(printer.print, numberOfTimes: 2) // => false
```

Mockery supports mocking functions with `void`, `optional` and `non-optional` results. It supports `values`, `structs`, `classes` and `enums` and doesn't put any restrains on the code you write.


## <a name="installation"></a>Installation

### <a name="spm"></a>Swift Package Manager

```
https://github.com/danielsaidi/Mockery.git
```

### <a name="cocoapods"></a>CocoaPods

```ruby
pod 'Mockery'
```

### <a name="carthage"></a>Carthage

```
github "danielsaidi/Mockery"
```


## Demo App

This repository contains a demo app that invokes various mock functions. To try it out, open and run the `Mockery.xcodeproj` project.


## Creating a mock

Consider that you have the following protocol:

```swift
protocol TestProtocol {
    
    func functionWithResult(arg1: String, arg2: Int) -> Int
    func functionWithOptionalResult(arg1: String, arg2: Int) -> Int?
    func functionWithVoidResult(arg: String)
}
```

To mock `TestProtocol`, just create a class that inherits `Mock` and implements `TestProtocol`:

```swift
class TestMock: Mock, TestProtocol {
    
    func functionWithResult(arg1: String, arg2: Int) -> Int {
        invoke(functionWithResult, args: (arg1, arg2))
    }

    func functionWithOptionalResult(arg1: String, arg2: Int) -> Int? {
        invoke(functionWithOptionalResult, args: (arg1, arg2))
    }
    
    func functionWithVoidResult(arg: String) {
        invoke(functionWithVoidResult, args: (arg))
    }
}
```

If your test class must inherit another class and therefore can't inherit `Mock`, you can let it implement `Mockable` instead. The rest is identical to using `Mock`.

The mock will now record the function calls and return any registered return values (or crash if you haven't registered any return values for non-optional functions).


## Registering return values

You can register return values by calling `registerResult(for:)`:

```swift
let mock = TestMock()
mock.registerResult(for: mock.functionWithIntResult) { _ in return 123 }
```

The result block takes the same arguments as the actual function, so you can adjust the function logic depending on the input arguments.

You don't have to register a return value for optional result functions. However, non-optional functions will crash if you fail to register a result before calling them.


## Inspecting invokations

Use `invokations(of:)` to inspect a mock's performed invokations. An invokation reference contains information on how many times the function was executed, with which input arguments and the result:

```swift
_ = mock.functionWithResult(arg1: "abc", arg2: 123)
_ = mock.functionWithResult(arg1: "abc", arg2: 456)

let inv = mock.invokations(of: mock.functionWithResult)
expect(inv.count).to(equal(2))
expect(inv[0].arguments.0).to(equal("abc"))
expect(inv[0].arguments.1).to(equal(123))
expect(inv[1].arguments.0).to(equal("abc"))
expect(inv[1].arguments.1).to(equal(456))
```

The syntax above uses [Quick/Nimble][Quick]. You can use any test framework you like.


## Registering and throwing errors

There is currently no support for registering and throwing errors, which means that async functions can't (yet) register custom return values.


## Device limitations

Mockery uses unsafe bit casts to get the memory address of mocked functions. This only works on 64-bit devices, which means that mock-based unit tests will not work on old devices or simulators like iPad 2, iPad Retina etc.


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
