# ``MockingKit``

MockingKit lets you mock protocols and classes in `Swift`.



## Overview

![MockingKit logo](Logo.png)

Mockinging is useful when unit testing, or to fake functionality that is not yet implemented.

MockingKit lets you create mocks of any protocol or open class, after which you can `call` functions, `register` results, `record` method invocations, and `inspect` recorded calls.

MockingKit doesn't require any setup or build scripts, and puts no restrictions on your code or architecture. Just create a mock and you're good to go.



## Installation

MockingKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/MockingKit.git
```

If you prefer to not have external dependencies, you can also just copy the source code into your app.



## Getting started

The <doc:Getting-Started> article helps you get started with ApiKit.



## Repository

For more information, source code, etc., visit the [project repository][Repository].



## License

ApiKit is available under the MIT license. See the [LICENSE][License] file for more info.



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



[License]: https://github.com/danielsaidi/MockingKit/blob/master/LICENSE
[Repository]: https://github.com/danielsaidi/MockingKit
