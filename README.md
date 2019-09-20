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

Mockery is a mocking library for Swift that helps you mock functionality e.g. when unit testing or developing new functionality. With Mockery, you can easily `register` return values, `invoke` method calls, `return` mocked return values and `inspect` function executions.

Mockery supports mocking functions with optional and non-optional return values as well as resultless ones. It supports values, structs, classes and enums and doesn't put any restrains on the code you write.


## <a name="installation"></a>Installation

### <a name="spm"></a>Swift Package Manager

In Xcode 11 and later, the easiest way to add Mockery to your project is to use Swift Package Manager:
```
.package(url: "git@github.com:danielsaidi/Mockery.git" ...)
```

### <a name="cocoapods"></a>CocoaPods

Add this to your `Podfile` and run `pod install`:
```ruby
pod 'Mockery'
```
After that, remember to use the generated workspace instead of the project file.

### <a name="carthage"></a>Carthage

Add this to your `Cartfile` and run `carthage update`:
```
github "danielsaidi/Mockery"
```
After that, check the Carthage docs for info on how to add the library to your app.

### <a name="manual-installation"></a>Manual installation

To add `Mockery` to your app without a dependency manager, clone this repository and place it somewhere on disk, then add `Mockery.xcodeproj` to the project and `Mockery.framework` as an embedded app binary and target dependency.


## Demo App

This repository contains a demo app. To try it out, open and run the `Mockery` project. The demo app is just a white screen that prints and alerts the result of using and inspecting some mocks.


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
        return invoke(functionWithResult, args: (arg1, arg2))
    }

    func functionWithOptionalResult(arg1: String, arg2: Int) -> Int? {
        return invoke(functionWithOptionalResult, args: (arg1, arg2))
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
        return recorder.invoke(functionWithResult, args: (arg1, arg2))
    }

    func functionWithOptionalResult(arg1: String, arg2: Int) -> Int? {
        return recorder.invoke(functionWithOptionalResult, args: (arg1, arg2))
    }
    
    func functionWithoutResult(arg: String) {
        recorder.invoke(functionWithoutResult, args: (arg))
    }
}
```

When you call these functions, the class will use its recorder torecord the invoked method calls and return any registered return values (or crash if...).


## Invoking function calls

Each mocked function must call `invoke` to record the function call together with the input arguments and possible return value. 

Void functions just have to call `invoke`. Functions with return values must call `return invoke`. If you haven't registered a return value, your app will crash.

After calling the mocked functions, you will be able to inspect the recorded function calls.


## Registering return values

If a mocked function returns a value, you must register the return value before invoking it. Failing to do so will make your tests crash with a `preconditionFailure`.

You register return values by calling the mock's (or recorder's) `registerResult(for:result:)` function, like this:

```swift
let mock = TestMock()
mock.registerResult(for: mock.functionWithIntResult) { _ in return 123 }
```

Since the result block takes in the same arguments as the actual function, you can return different result values depending on the input arguments.

You don't have to register a return value for functions that return an optional value. Invoking such a function will returnjust return `nil`.


## Inspecting executions

To inspect a mock, you can use `executions(for:)` to get information on how many times a function did receive a call, with which input arguments and what result it returned:

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

In case you don't recognize the syntax above, the test uses [Quick/Nimble][Quick].


## Registering and throwing errors

There is currently no support for registering and throwing errors, which means that async functions can't (yet) register custom return values. 

Until this is implemented, you can use the `Mock` class' `error` property.


## Device limitations

Mockery uses unsafe bit casts to get the memory address of mocked functions. This only works on 64-bit devices, which means that mock-based unit tests will not work on old devices or simulators like iPad 2, iPad Retina etc.


## Contact me

I hope you like this library. Feel free to reach out if you have questions or if you want to contribute in any way:

* E-mail: [daniel.saidi@gmail.com](mailto:daniel.saidi@gmail.com)
* Twitter: [@danielsaidi](http://www.twitter.com/danielsaidi)
* Web site: [danielsaidi.com](http://www.danielsaidi.com)


## Acknowledgements

Mockery is inspired by [Stubber][Stubber], and would not have been possible without it. The entire function address approach and escape support etc. comes from Stubber, and this mock implementation comes from there as well.

However, while Stubber uses global functions (which requires you to reset the global state every now and then), Mockery moves this logic to each mock, which means that any recorded exeuctions are automatically reset when the mock is disposed. Mockery also adds some extra functionality, like support for optional and void results.


## License

Mockery is available under the MIT license. See the [LICENSE][License] file for more info.


[Carthage]: https://github.com/Carthage
[CocoaPods]: http://cocoapods.org
[GitHub]: https://github.com/danielsaidi/Mockery
[Pod]: http://cocoapods.org/pods/Mockery
[Quick]: https://github.com/Quick/Quick
[Stubber]: https://github.com/devxoul/Stubber
[License]: https://github.com/danielsaidi/Mockery/blob/master/LICENSE
