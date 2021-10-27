<h1>MockingKit</h1>

<p align="center">
    <img src ="Resources/Logo.png" alt="MockingKit Logo" /><br/>
    <img src="https://img.shields.io/github/v/release/danielsaidi/MockingKit?color=%2300550&sort=semver" alt="Version" />
    <img src="https://img.shields.io/badge/Swift-5.3-orange.svg" alt="Swift 5.3" />
    <img src="https://img.shields.io/github/license/danielsaidi/KeyboardKit" alt="MIT License" />
    <a href="https://twitter.com/danielsaidi">
        <img src="https://img.shields.io/badge/contact-@danielsaidi-blue.svg?style=flat" alt="Twitter: @danielsaidi" />
    </a>
</p>


## <a name="about"></a>About MockingKit

MockingKit is a Swift-based mocking library that makes it easy to mock protocols and classes. It lets you `register` function results, `call` functions and `inspect` calls.


## Getting started

MockingKit can be used to mock any protocol or class.

For instance, say that you have a `MyProtocol` protocol:


```swift
protocol MyProtocol {
    func doStuff(int: Int, string: String) -> String
}
```

You can then create a mock implementation of the protocol by creating a mock class that inherits the `Mock` base class and implements `MyProtocol`:

```swift
class MyMock: Mock, MyProtocol {

    // You have to define a lazy reference for each function 
    lazy var doStuffRef = MockReference(doStuff)

    // Functions must then call the reference to be recorded
    func doStuff(int: Int, string: String) -> String {
        call(doStuffRef, args: (int, string))
    }
}
```

If your mock can't inherit `Mock`, e.g. when mocking structs or when the mock must inherit another base class, you can implement the `Mockable` protocol by just providing a custom `mock` instance: 

```swift
class MyMock: MyBaseClass, Mockable, MyProtocol {

    let mock = Mock()
    
    // ... the rest is the same. `Mock` just saves you one line of code :)
}
```

You can now use the mock to `register` function results, `call` functions and `inspect` calls:

```swift

// Create a mock
let mock = MyMock()

// Register a result for when calling doStuff
mock.registerResult(for: mock.doStuffRef) { args in String(args.1.reversed()) }

// Calling doStuff will now return the pre-registered result
let result = mock.doStuff(int: 42, string: "string")    // => "gnirts"

// You can also inspect all calls that made to doStuff
let calls = mock.calls(to: mock.doStuffRef)             // => 1 item
calls[0].arguments.0                                    // => 42
calls[0].arguments.1                                    // => "string"
calls[0].result                                         // => "gnirts"
mock.hasCalled(mock.doStuffRef)                         // => true
mock.hasCalled(mock.doStuffRef, numberOfTimes: 1)       // => true
mock.hasCalled(mock.doStuffRef, numberOfTimes: 2)       // => false
```

This can be used when unit testing, mock not yet implemented functionality etc.


## Capabilities

MockingKit supports

* mocking protocols
* mocking classes
* mocking system classes, like `UserDefaults`
* mocking returning and non-returning (void) functions
* mocking synchronous and asynchronous functions
* `void`, `optional` and `non-optional` result values
* argument-based results

MockingKit doesn't put any restrains on your code or require you to structure it in any way. You don't need any setup or configuration. Just create a mock and you're good to go.


## <a name="installation"></a>Installation

### <a name="spm"></a>Swift Package Manager

```
https://github.com/danielsaidi/MockingKit.git
```

### <a name="cocoapods"></a>CocoaPods

```ruby
pod 'MockingKit'
```

## Demo App

This repository contains a demo app that shows you how to use MockingKit. 

To run it, just open and run `Demo/Demo.xcodeproj`.


## Contact me

Feel free to reach out if you have questions or if you want to contribute in any way:

* E-mail: [daniel.saidi@gmail.com][Email]
* Twitter: [@danielsaidi][Twitter]
* Web site: [danielsaidi.com][Website]


## Support

You can sponsor this project on [GitHub Sponsors][Sponsors] or get in touch for paid support.


## Acknowledgements

MockingKit is based on [Stubber][Stubber], and would not have been possible without it. 


## License

MockingKit is available under the MIT license. See the [LICENSE][License] file for more info.


[Email]: mailto:daniel.saidi@gmail.com
[Twitter]: http://www.twitter.com/danielsaidi
[Website]: http://www.danielsaidi.com
[Sponsors]: https://github.com/sponsors/danielsaidi

[Example]: https://github.com/danielsaidi/MockingKit/blob/master/Readmes/Example.md

[CocoaPods]: http://cocoapods.org
[GitHub]: https://github.com/danielsaidi/MockingKit
[Pod]: http://cocoapods.org/pods/MockingKit
[Stubber]: https://github.com/devxoul/Stubber
[License]: https://github.com/danielsaidi/MockingKit/blob/master/LICENSE
