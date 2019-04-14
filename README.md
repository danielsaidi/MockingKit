<p align="center">
    <img src ="Resources/Logo.png" width=400 />
</p>

<p align="center">
    <a href="https://github.com/danielsaidi/MockNRoll">
        <img src="https://badge.fury.io/gh/danielsaidi%2FMockNRoll.svg?style=flat" alt="Version" />
    </a>
    <img src="https://api.travis-ci.org/danielsaidi/MockNRoll.svg" alt="Build Status" />
    <a href="https://cocoapods.org/pods/MockNRoll">
        <img src="https://img.shields.io/cocoapods/v/MockNRoll.svg?style=flat" alt="CocoaPods" />
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/carthage-supported-green.svg?style=flat" alt="Carthage" />
    </a>
    <img src="https://img.shields.io/cocoapods/p/MockNRoll.svg?style=flat" alt="Platform" />
    <img src="https://img.shields.io/badge/Swift-4.2-orange.svg" alt="Swift 4.2" />
    <img src="https://badges.frapsoft.com/os/mit/mit.svg?style=flat&v=102" alt="License" />
    <a href="https://twitter.com/danielsaidi">
        <img src="https://img.shields.io/badge/contact-@danielsaidi-blue.svg?style=flat" alt="Twitter: @danielsaidi" />
    </a>
</p>


## <a name="about"></a>About MockNRoll

MockNRoll is a tiny Swift mocking library. It comes with a `Mock` class, that helps you create powerful mock classes for your unit tests.


## <a name="installation"></a>Installation

### <a name="cocoapods"></a>CocoaPods

To install MockNRoll with [CocoaPods][CocoaPods], add this to your `Podfile`:

```ruby
pod 'MockNRoll'
```

### <a name="carthage"></a>Carthage

To install MockNRoll with [Carthage][Carthage], add this to your `Cartfile`:

```ruby
github "danielsaidi/MockNRoll"
```

### <a name="manual-installation"></a>Manual installation

To add `MockNRoll` to your app without using Carthage or CocoaPods, clone this repository and place it somewhere on disk, then add `MockNRoll.xcodeproj` to your project and add `MockNRoll.framework` as an embedded app binary and target dependency.


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

To create a mocked `TestProtocol`, you just have to inherit `Mock` and implement `TestProtocol`, for instance:

```swift
class TestClass: Mock, TestProtocol {
    
    func functionWithIntResult(arg1: String, arg2: Int) -> Int {}
    func functionWithStringResult(arg1: String, arg2: Int) -> String {}
    func functionWithStructResult(arg1: String, arg2: Int) -> User {}
    func functionWithClassResult(arg1: String, arg2: Int) -> Thing {}
    
    func functionWithOptionalIntResult(arg1: String, arg2: Int) -> Int? {}
    func functionWithOptionalStringResult(arg1: String, arg2: Int) -> String? {}
    func functionWithOptionalStructResult(arg1: String, arg2: Int) -> User? {}
    func functionWithOptionalClassResult(arg1: String, arg2: Int) -> Thing? {}
    
    func functionWithVoidResult(arg1: String, arg2: Int) {}
```

However, this does not do anything yet. To make use of the mock class, we must:

* `invoke` each function to make the mock record the function call, including the input arguments and return value
* make the test class `register` return values for the functions we want to test
* check the invoked `executions` to assert that the test was successful


## Invoking function calls

Each mock class function must call `invoke` to make the mock record the function call, including the input arguments and return value. For the `TestClass` above, it would look something like this:

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

Whenever your unit tests touch any of these functions, we will be able to control the result value and check that the mock is called as expected.


## Registering values

For functions that return a value, your tests must register the actual return values before the tests touch the mock functions. Failing to do so will make your tests crash with a `preconditionFailure`.

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

You don't have to do this for void functions or functions that return an optional value.


## Asserting mock executions

To check that a mock receives the expected function calls in a test suite, you can check the `executions(for:)` function to get information about how many times a functions received a call, with which input arguments and the returned result:

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


## Contact me

I hope you like this library. Feel free to reach out if you have questions or if you want to contribute in any way:

* E-mail: [daniel.saidi@gmail.com](mailto:daniel.saidi@gmail.com)
* Twitter: [@danielsaidi](http://www.twitter.com/danielsaidi)
* Web site: [danielsaidi.com](http://www.danielsaidi.com)


## License

MockNRoll is available under the MIT license. See LICENSE file for more info.


[Carthage]: https://github.com/Carthage
[CocoaPods]: http://cocoapods.org
[GitHub]: https://github.com/danielsaidi/MockNRoll
[Pod]: http://cocoapods.org/pods/MockNRoll
[Quick]: https://github.com/Quick/Quick
[License]: https://github.com/danielsaidi/MockNRoll/blob/master/LICENSE