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

MockingKit is a Swift-based mocking library that makes it easy to mock protocols and classes. It lets you `register` function results, `call` functions and `inspect` calls:

```swift
protocol MyProtocol {
    func doStuff(int: Int, string: String) -> String
}

class MyMock: Mock, MyProtocol {

    lazy var doStuffRef = MockReference(doStuff)  // References must be lazy

    func doStuff(int: Int, string: String) -> String {
        call(doStuffRef, args: (int, string))
    }
}

let mock = MyMock()
mock.registerResult(for: mock.doStuffRef) { args in String(args.1.reversed()) }
let result = mock.doStuff(int: 42, string: "string")    // => "gnirts"
let calls = mock.calls(to: mock.doStuffRef)             // => 1 item
calls[0].arguments.0                                    // => 42
calls[0].arguments.1                                    // => "string"
calls[0].result                                         // => "gnirts"
mock.hasCalled(mock.doStuffRef)                         // => true
mock.hasCalled(mock.doStuffRef, numberOfTimes: 1)       // => true
mock.hasCalled(mock.doStuffRef, numberOfTimes: 2)       // => false
```

MockingKit supports:
* mocking protocols
* mocking classes
* mocking non-returning and returning functions
* mocking synchronous and asynchronous functions
* `void`, `optional` and `non-optional` result values
* argument-based results

MockingKit doesn't put any restrains on your code or require you to structure it in any way. You don't need any setup or configuration. Just create a mock and you're good to go.

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

MockingKit is based on [Stubber][Stubber], and would not have been possible without it. 


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
