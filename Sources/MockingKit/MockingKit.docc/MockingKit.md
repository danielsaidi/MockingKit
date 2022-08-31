# ``MockingKit``

MockingKit is a Swift-based mocking library that makes it easy to mock protocols and classes, for instance when unit testing or mocking not yet implemented functionality.


## Overview

![MockingKit logo](Logo.png)

MockingKit lets you `register` function results, `invoke` functions and `inspect` calls.

MockingKit doesn't put any restrains on your code or require you to structure it in any way. You don't need any setup or configuration. Just create a mock and you're good to go.



## Supported Platforms

MockingKit supports `iOS 9`, `macOS 10.10`, `tvOS 9` and `watchOS 6`.



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



## About this documentation

The online documentation is currently iOS-specific. To generate documentation for other platforms, open the package in Xcode, select a simulator then run `Product/Build Documentation`.



## License

MockingKit is available under the MIT license.



## Topics

### Articles

- <doc:Getting-Started>

### Foundation

- ``Mock``
- ``Mockable``
- ``MockCall``
- ``MockReference``
- ``AsyncMockReference``

### System Mocks

- ``MockNotificationCenter``
- ``MockPasteboard``
- ``MockTextDocumentProxy``
- ``MockUserDefaults``
