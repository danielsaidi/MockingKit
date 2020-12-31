<h1>Mockery</h1>

<p align="center">
    <img src ="Resources/Logo.png" alt="Mockery Logo" /><br/>
    <img src="https://img.shields.io/github/v/release/danielsaidi/Mockery?color=%2300550&sort=semver" alt="Version" />
    <img src="https://img.shields.io/badge/Swift-5.3-orange.svg" alt="Swift 5.3" />
    <img src="https://img.shields.io/github/license/danielsaidi/KeyboardKit" alt="MIT License" />
    <a href="https://twitter.com/danielsaidi">
        <img src="https://img.shields.io/badge/contact-@danielsaidi-blue.svg?style=flat" alt="Twitter: @danielsaidi" />
    </a>
</p>


## <a name="about"></a>About Mockery

Mockery is a mocking library for Swift. Mockery lets you `register` function results, `invoke` method calls and `inspect` invokations:

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

Mockery supports:

* mocking protocols
* mocking classes (using [`Mockable`][Mockable])
* mocking synchronous and asynchronous functions.
* mocking non-returning and returning functions.
* `void`, `optional` and `non-optional` result values.
* argument-based, variable result values.

Mockery doesn't put any restrains on your code or require you to structure it in any way. Just create a mock when you want to mock a protocol and you're good to go.

For more information, have a look at this [detailed example][Example].


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

This repository contains a demo app that shows you how to use Mockery. To run it, just open and run `MockeryDemo.xcodeproj`.


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

[Example]: https://github.com/danielsaidi/Mockery/blob/master/Readmes/Example.md

[CocoaPods]: http://cocoapods.org
[GitHub]: https://github.com/danielsaidi/Mockery
[Pod]: http://cocoapods.org/pods/Mockery
[Stubber]: https://github.com/devxoul/Stubber
[License]: https://github.com/danielsaidi/Mockery/blob/master/LICENSE
