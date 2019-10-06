<h1>Mockery</h1>

<p align="center">
    <img src ="Resources/Logo.png" width=200 alt="Mockery Icon" /><br/>
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

Mockery is a mocking library for Swift. It helps you mock functionality e.g. when unit testing or developing new functionality. With Mockery, you can `register` return values, `invoke` method calls, `return` mocked return values and `inspect` function executions.

Mockery supports mocking functions with void, optional and non-optional results. It supports values, structs, classes and enums and doesn't put any restrains on the code you write.


## <a name="installation"></a>Installation

### <a name="spm"></a>Swift Package Manager

The easiest way to add Mockery to your project is to use Swift Package Manager:
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

### <a name="manual-installation"></a>Manual installation

To add `Mockery` to your app without a dependency manager, clone this repository and place it somewhere on disk, then add `Mockery.xcodeproj` to the project and `Mockery.framework` as an embedded app binary and target dependency.


## Demo App

This repository contains a demo app that wires up a couple of mocks and invokes various functions. To try it out, open and run the `Mockery.xcodeproj` project.


## Creating a mock

Consider that you have the following protocol:

```swift
protocol TestProtocol {
    
    func functionWithResult(arg1: String, arg2: Int) -> Int
    func functionWithOptionalResult(arg1: String, arg2: Int) -> Int?
    func functionWithoutResult(arg: String)
}
```

To mock `TestProtocol`, you just have to create a mock class that inherits `Mock` and implements `TestProtocol`:

```swift
class TestMock: Mock, TestProtocol {
    
    func functionWithResult(arg1: String, arg2: Int) -> Int {
        invoke(functionWithResult, args: (arg1, arg2))
    }

    func functionWithOptionalResult(arg1: String, arg2: Int) -> Int? {
        invoke(functionWithOptionalResult, args: (arg1, arg2))
    }
    
    func functionWithoutResult(arg: String) {
        invoke(functionWithoutResult, args: (arg))
    }
}
```

When you call these functions, the mock will record the invoked method calls and return any registered return values (or crash if you haven't registered any).


## Using a mock recorder

If your mock has to inherit another class (e.g. a mocked view controller), you can use a mock recorder under the hood, like this:

```swift
class TestMock: TestClass, TestProtocol {

    var recorder = Mock()
    
    func functionWithResult(arg1: String, arg2: Int) -> Int {
        recorder.invoke(functionWithResult, args: (arg1, arg2))
    }

    func functionWithOptionalResult(arg1: String, arg2: Int) -> Int? {
        recorder.invoke(functionWithOptionalResult, args: (arg1, arg2))
    }
    
    func functionWithoutResult(arg: String) {
        recorder.invoke(functionWithoutResult, args: (arg))
    }
}
```

When you call these functions, the class will use its recorder to record the invoked method calls and return any registered return values.


## Invoking function calls

Each mocked function must call `invoke` to record the function call. After calling the mocked functions, you can inspect the recorded function calls. If you haven't registered a return value, your app will crash.


## Registering return values

You can register return values by calling the mock's (or recorder's) `registerResult(for:result:)` function:

```swift
let mock = TestMock()
mock.registerResult(for: mock.functionWithIntResult) { _ in return 123 }
```

The result block takes the same arguments as the actual function, so you can adjust the function logic depending on the input arguments. You don't have to register a return value for functions that return an optional value.


## Inspecting executions

To inspect the performed exeuctions of a mock, you can use `executions(for:)`. It contains information on how many times a function was executed, with which input arguments and the returned result:

```swift
_ = mock.functionWithResult(arg1: "abc", arg2: 123)
_ = mock.functionWithResult(arg1: "abc", arg2: 456)

let executions = mock.executions(of: mock.functionWithIntResult)
expect(executions.count).to(equal(3))
expect(executions[0].arguments.0).to(equal("abc"))
expect(executions[0].arguments.1).to(equal(123))
expect(executions[1].arguments.0).to(equal("abc"))
expect(executions[1].arguments.1).to(equal(456))
```

In case you don't recognize the syntax above, the test uses [Quick/Nimble][Quick]. You can use any unit test framework you like.


## Registering and throwing errors

There is currently no support for registering and throwing errors, which means that async functions can't (yet) register custom return values. Until this is implemented, you can use the `Mock` `error` property.


## Device limitations

Mockery uses unsafe bit casts to get the memory address of mocked functions. This only works on 64-bit devices, which means that mock-based unit tests will not work on old devices or simulators like iPad 2, iPad Retina etc.


## Contact me

Feel free to reach out if you have questions or if you want to contribute in any way:

* E-mail: [daniel.saidi@gmail.com][Email]
* Twitter: [@danielsaidi][Twitter]
* Web site: [danielsaidi.com][Website]


## Acknowledgements

Mockery is inspired by [Stubber][Stubber], and would not have been possible without it. The entire function address approach and escape support etc. comes from Stubber, and this mock implementation comes from there as well.

However, while Stubber uses global functions (which requires you to reset the global state every now and then), Mockery moves this logic to each mock, which means that any recorded exeuctions are automatically reset when the mock is disposed. Mockery also adds some extra functionality, like support for optional and void results.


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
