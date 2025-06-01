# ``MockingKit``

MockingKit is a Swift SDK that lets you easily mock protocols and classes in `Swift`.



## Overview

![MockingKit logo](Logo.png)

MockingKit is a mocking library for Swift that lets you create mocks of any protocol or class. This can be used to mock dependencies in unit tests, and to fake not yet implemented features in your apps.  

MockingKit automatically records all method calls, to let you verify that your code behaves as you expect. You can also register register dynamic function results to control your test outcome.

MockingKit doesn't require any setup or build scripts, and puts no restrictions on your code or architecture. Just create a mock, set up how you want to use and inspect it, and you're good to go.



## Installation

MockingKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/MockingKit.git
```



## Getting started

The <doc:Getting-Started> article helps you get started with MockingKit.



## Repository

For more information, source code, etc., visit the [project repository](https://github.com/danielsaidi/MockingKit).



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
- ``MockUserDefaults``
