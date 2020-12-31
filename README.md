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

MockingKit is a Swift mocking library that makes it easy to mock protocol implementations for unit tests and not yet implemented functionality. 

MockingKit lets you `register` function results, `invoke` method calls and `inspect` invokations:

```swift
protocol MyProtocol {
    func doStuff(int: Int, string: String) -> String
}

class MyMock: Mock, MyProtocol {

    lazy var doStuffRef = MockReference(doStuff)  // This has to be lazy

    func doStuff(int: Int, string: String) -> String {
        invoke(doStuffRef, args: (int, string))
    }
}

let mock = MyMock()
mock.registerResult(for: mock.doStuffRef) { args in String(args.1.reversed()) }
let result = mock.doStuff(int: 42, string: "string")    // => "gnirts"
let inv = mock.invokations(of: mock.doStuffRef)         // => 1 item
inv[0].arguments.0                                      // => 42
inv[0].arguments.1                                      // => "message"
inv[0].result                                           // => "gnirts"
mock.hasInvoked(mock.doStuffRef)                        // => true
mock.hasInvoked(mock.doStuffRef, numberOfTimes: 1)      // => true
mock.hasInvoked(mock.doStuffRef, numberOfTimes: 2)      // => false
```

MockingKit supports:

* mocking protocols
* mocking classes (using [`Mockable`][Mockable])
* mocking synchronous and asynchronous functions.
* mocking non-returning and returning functions.
* `void`, `optional` and `non-optional` result values.
* argument-based, variable result values.

MockingKit doesn't put any restrains on your code or require you to structure it in any way. Just create a mock when you want to mock a protocol and you're good to go.

For more information, have a look at this [detailed example][Example].


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


## Acknowledgements

MockingKit is inspired by [Stubber][Stubber], and would not have been possible without it. 

However, while Stubber uses global state, MockingKit moves this state to each mock. This means that recorded exeuctions are automatically reset when a mock is disposed. 

MockingKit also adds some extra functionality, like support for optional and void results and convenient inspection utilities.


## License

MockingKit is available under the MIT license. See the [LICENSE][License] file for more info.


[Email]: mailto:daniel.saidi@gmail.com
[Twitter]: http://www.twitter.com/danielsaidi
[Website]: http://www.danielsaidi.com

[Example]: https://github.com/danielsaidi/MockingKit/blob/master/Readmes/Example.md

[CocoaPods]: http://cocoapods.org
[GitHub]: https://github.com/danielsaidi/MockingKit
[Pod]: http://cocoapods.org/pods/MockingKit
[Stubber]: https://github.com/devxoul/Stubber
[License]: https://github.com/danielsaidi/MockingKit/blob/master/LICENSE
