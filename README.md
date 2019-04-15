<p align="center">
    <img src ="Resources/Logo.png" width=400 />
</p>

<p align="center">
    <a href="https://github.com/danielsaidi/MockNRoll">
        <img src="https://badge.fury.io/gh/danielsaidi%2FMockNRoll.svg?style=flat" alt="Version" />
    </a>
    <a href="https://cocoapods.org/pods/MockNRoll">
        <img src="https://img.shields.io/cocoapods/v/MockNRoll.svg?style=flat" alt="CocoaPods" />
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/carthage-supported-green.svg?style=flat" alt="Carthage" />
    </a>
    <img src="https://img.shields.io/cocoapods/p/MockNRoll.svg?style=flat" alt="Platform" />
    <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" alt="Swift 5.0" />
    <img src="https://badges.frapsoft.com/os/mit/mit.svg?style=flat&v=102" alt="License" />
    <a href="https://twitter.com/danielsaidi">
        <img src="https://img.shields.io/badge/contact-@danielsaidi-blue.svg?style=flat" alt="Twitter: @danielsaidi" />
    </a>
</p>


## <a name="about"></a>About Mock 'n' Roll

Mock 'n' Roll is a mock library for Swift, that helps you mock functionality when unit testing. You can `invoke` method calls with full argument support, `register` return values for any function and `inspect` executions on your mocks.

Mock 'n' Roll supports mocking functions with optional and non-optional return values, as well as resultless functions. It supports values, structs, classes and enums and doesn't put any restrains on the code you write.


## Creating a mock

Consider that you have the following protocol:

```swift
protocol TestProtocol {
    
    func functionWithIntResult(arg1: String, arg2: Int) -> Int
    func functionWithStringResult(arg1: String, arg2: Int) -> String
    func functionWithStructResult(arg1: String, arg2: Int) -> User
    func functionWithClassResult(arg1: String, arg2: Int) -> Thing
    
    func functionWithOptionalIntResult(arg1: String, arg2: Int) -> Int?
    func functionWithOptionalStringResult(arg1: String, arg2: Int) -> String?
    func functionWithOptionalStructResult(arg1: String, arg2: Int) -> User?
    func functionWithOptionalClassResult(arg1: String, arg2: Int) -> Thing?
    
    func functionWithVoidResult(arg1: String, arg2: Int)
}
```

To mock `TestProtocol`, you just have to create a class that inherits `Mock` and implements `TestProtocol`:

```swift
class TestClass: Mock, TestProtocol {
    
    func functionWithIntResult(arg1: String, arg2: Int) -> Int { ... }
    func functionWithStringResult(arg1: String, arg2: Int) -> String { ... }
    func functionWithStructResult(arg1: String, arg2: Int) -> User { ... }
    func functionWithClassResult(arg1: String, arg2: Int) -> Thing { ... }
    
    func functionWithOptionalIntResult(arg1: String, arg2: Int) -> Int? { ... }
    func functionWithOptionalStringResult(arg1: String, arg2: Int) -> String? { ... }
    func functionWithOptionalStructResult(arg1: String, arg2: Int) -> User? { ... }
    func functionWithOptionalClassResult(arg1: String, arg2: Int) -> Thing? { ... }
    
    func functionWithVoidResult(arg1: String, arg2: Int) {}
```

To make use of the mock class, you must then:

* call `invoke` in each function to record all function calls as well as their arguments and return values
* make your tests `register` any required return values for any functions you want to test
* make your tests check the mock's `executions` to assert that the tests were successfully executed


## Invoking function calls

Each mocked function must call `invoke` to record the function call, including the input arguments and return value. For the `TestClass` above, it would look something like this:

```swift
class TestClass: Mock, TestProtocol {
    
    func functionWithIntResult(arg1: String, arg2: Int) -> Int {
        return invoke(functionWithIntResult, args: (arg1, arg2))
    }
    
    func functionWithStringResult(arg1: String, arg2: Int) -> String {
        return invoke(functionWithStringResult, args: (arg1, arg2))
    }
    
    func functionWithStructResult(arg1: String, arg2: Int) -> User {
        return invoke(functionWithStructResult, args: (arg1, arg2))
    }
    
    func functionWithClassResult(arg1: String, arg2: Int) -> Thing {
        return invoke(functionWithClassResult, args: (arg1, arg2))
    }
    
    
    func functionWithOptionalIntResult(arg1: String, arg2: Int) -> Int? {
        return invoke(functionWithOptionalIntResult, args: (arg1, arg2))
    }
    
    func functionWithOptionalStringResult(arg1: String, arg2: Int) -> String? {
        return invoke(functionWithOptionalStringResult, args: (arg1, arg2))
    }
    
    func functionWithOptionalStructResult(arg1: String, arg2: Int) -> User? {
        return invoke(functionWithOptionalStructResult, args: (arg1, arg2))
    }
    
    func functionWithOptionalClassResult(arg1: String, arg2: Int) -> Thing? {
        return invoke(functionWithOptionalClassResult, args: (arg1, arg2))
    }
    
    
    func functionWithVoidResult(arg1: String, arg2: Int) {
        invoke(functionWithVoidResult, args: (arg1, arg2))
    }
}
```

Void functions just have to call `invoke` while returning functions must call `return invoke`.

Whenever your unit tests touch any of these functions, you will now be able to inspect the recorded function calls to verify that the mock is called as expected.


## Registering values

For functions that return a non-optional value, your tests must register the actual return values before touching the mocked functions. Failing to do so will make your tests crash with a `preconditionFailure`.

You register return values by calling the mock's `registerResult(for:result:)` function, like this:

```swift
let mock = TestClass()
mock.registerResult(for: mock.functionWithIntResult) { _ in return 123 }
```

Since the result block takes in the same arguments as the actual function, you can return different result values depending on the input arguments:

```swift
let mock = TestClass()
mock.registerResult(for: mock.functionWithIntResult) { _, arg2 in  return arg2 }
mock.registerResult(for: mock.functionWithStringResult) { arg1, _ in  return arg1 }
```

You don't have to register a return value for void functions or functions that return an optional value, but you should do so whenever you want to affect your tests.


## Asserting mock executions

To verify that a mock receives the expected function calls, you can use `executions(for:)` to get information on how many times a function did receive a call, with which input arguments and what result it returned:

```swift
_ = mock.functionWithIntResult(arg1: "abc", arg2: 123)
_ = mock.functionWithIntResult(arg1: "abc", arg2: 456)
_ = mock.functionWithIntResult(arg1: "abc", arg2: 789)
_ = mock.functionWithStringResult(arg1: "abc", arg2: 123)
_ = mock.functionWithStringResult(arg1: "def", arg2: 123)

let intExecutions = mock.executions(of: mock.functionWithIntResult)
let stringExecutions = mock.executions(of: mock.functionWithStringResult)
expect(intExecutions.count).to(equal(3))
expect(stringExecutions.count).to(equal(2))
expect(intExecutions[0].arguments.0).to(equal("abc"))
expect(intExecutions[0].arguments.1).to(equal(123))
expect(intExecutions[1].arguments.0).to(equal("abc"))
expect(intExecutions[1].arguments.1).to(equal(456))
expect(intExecutions[2].arguments.0).to(equal("abc"))
expect(intExecutions[2].arguments.1).to(equal(789))
expect(stringExecutions[0].arguments.0).to(equal("abc"))
expect(stringExecutions[0].arguments.1).to(equal(123))
expect(stringExecutions[1].arguments.0).to(equal("def"))
expect(stringExecutions[1].arguments.1).to(equal(123))
```

Note that the code above uses [Quick/Nimble][Quick], in case you don't recognize the syntax.


## Registering and throwing errors

There is currently no support for registering and throwing errors, which means that async functions can't (yet) register custom return values. Until this is implemented, you can use the `Mock` class' `error` property.


## <a name="installation"></a>Installation

### <a name="cocoapods"></a>CocoaPods

To install Mock 'n' Roll with [CocoaPods][CocoaPods], add this to your `Podfile`:

```ruby
pod 'MockNRoll'
```

### <a name="carthage"></a>Carthage

To install Mock 'n' Roll with [Carthage][Carthage], add this to your `Cartfile`:

```ruby
github "danielsaidi/MockNRoll"
```

### <a name="manual-installation"></a>Manual installation

To add Mock 'n' Roll to your app without using Carthage or CocoaPods, clone this repository and place it somewhere on disk, then add `MockNRoll.xcodeproj` to your project and add `MockNRoll.framework` as an embedded app binary and target dependency.


## Contact me

I hope you like this library. Feel free to reach out if you have questions or if you want to contribute in any way:

* E-mail: [daniel.saidi@gmail.com](mailto:daniel.saidi@gmail.com)
* Twitter: [@danielsaidi](http://www.twitter.com/danielsaidi)
* Web site: [danielsaidi.com](http://www.danielsaidi.com)


## Acknowledgements

Mock 'n' Roll is inspired by [Stubber][Stubber], but has a completely separate code base. While Stubber uses global functions (which requires you to empty the execution store every now and then), Mock 'n' Roll moves this logic to each mock, which means that any recorded exeuctions are automatically cleared when the mock is disposed. Mock 'n' Roll also adds some extra functionality, like optional and void result support.


## License

Mock 'n' Roll is available under the MIT license. See the [LICENSE][License] file for more info.


[Carthage]: https://github.com/Carthage
[CocoaPods]: http://cocoapods.org
[GitHub]: https://github.com/danielsaidi/MockNRoll
[Pod]: http://cocoapods.org/pods/MockNRoll
[Quick]: https://github.com/Quick/Quick
[Stubber]: https://github.com/devxoul/Stubber
[License]: https://github.com/danielsaidi/MockNRoll/blob/master/LICENSE