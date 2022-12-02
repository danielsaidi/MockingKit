<p align="center">
    <img src ="Resources/Logo.png" alt="MockingKit Logo" title="MockingKit" width=600 />
</p>

<p align="center">
    <img src="https://img.shields.io/github/v/release/danielsaidi/MockingKit?color=%2300550&sort=semver" alt="Version" />
    <img src="https://img.shields.io/badge/Swift-5.6-orange.svg" alt="Swift 5.6" />
    <img src="https://img.shields.io/github/license/danielsaidi/MockingKit" alt="MIT License" />
    <a href="https://twitter.com/danielsaidi">
        <img src="https://img.shields.io/badge/contact-@danielsaidi-blue.svg?style=flat" alt="Twitter: @danielsaidi" />
    </a>
</p>


## About MockingKit

MockingKit is a Swift-based mocking library that makes it easy to mock protocols and classes, for instance when unit testing or mocking not yet implemented functionality.

MockingKit lets you `register` function results, `call` functions and `inspect` recorded calls.

MockingKit doesn't put any restrictions on your code or require you to structure it in any way. You don't need any setup or configuration. Just create a mock and you're good to go.



## Supported Platforms

MockingKit supports `iOS 13`, `macOS 10.15`, `tvOS 13` and `watchOS 6`.



## Installation

MockingKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/MockingKit.git
```

or with CocoaPods:

```
pod MockingKit
```

You can also clone the repository and build the library locally.



## Getting started

In short, MockingKit lets you mock any protocols and classes:

```swift
protocol MyProtocol {

    func doStuff(int: Int, string: String) -> String
}

class MyMock: Mock, MyProtocol {

    // You have to define a lazy reference for each function you want to mock
    lazy var doStuffRef = MockReference(doStuff)

    // Functions must then call the reference to be recorded
    func doStuff(int: Int, string: String) -> String {
        call(doStuffRef, args: (int, string))
    }
}
```

You can then use the mock to `register` function results, `call` functions and `inspect` recorded calls.

```swift
// Create a mock
let mock = MyMock()

// Register a doStuff result
mock.registerResult(for: mock.doStuffRef) { args in String(args.1.reversed()) }

// Calling doStuff will now return the pre-registered result
let result = mock.doStuff(int: 42, string: "string") // => "gnirts"

// You can now inspect calls made to doStuff
let calls = mock.calls(to: mock.doStuffRef)          // => 1 item
calls[0].arguments.0                                 // => 42
calls[0].arguments.1                                 // => "string"
calls[0].result                                      // => "gnirts"
mock.hasCalled(\.doStuffRef)                         // => true
mock.hasCalled(\.doStuffRef, numberOfTimes: 1)       // => true
mock.hasCalled(\.doStuffRef, numberOfTimes: 2)       // => false
```

The online documentation has a more thorough [getting-started guide][Getting-Started] that will help you get started with the library. 



## Documentation

The [online documentation][Documentation] has articles, code examples etc. that let you overview the various parts of the library.

The online documentation is currently iOS-specific. To generate documentation for other platforms, open the package in Xcode, select a simulator then run `Product/Build Documentation`. 



## Demo Application

This project contains a demo app that lets you explore MockingKit on iOS and macOS. To run it, just open and run `Demo/Demo.xcodeproj`.



## Support

You can sponsor this project on [GitHub Sponsors][Sponsors] or get in touch for paid support. 



## Contact

Feel free to reach out if you have questions or if you want to contribute in any way:

* E-mail: [daniel.saidi@gmail.com][Email]
* Twitter: [@danielsaidi][Twitter]
* Web site: [danielsaidi.com][Website]



## License

MockingKit is available under the MIT license. See the [LICENSE][License] file for more info.



[Email]: mailto:daniel.saidi@gmail.com
[Twitter]: http://www.twitter.com/danielsaidi
[Website]: http://www.danielsaidi.com
[Sponsors]: https://github.com/sponsors/danielsaidi

[Documentation]: https://danielsaidi.github.io/MockingKit/documentation/mockingkit/
[Getting-Started]: https://danielsaidi.github.io/MockingKit/documentation/mockingkit/getting-started
[License]: https://github.com/danielsaidi/MockingKit/blob/master/LICENSE
