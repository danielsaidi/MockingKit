# Getting started

This article describes how you get started with MockingKit.


## Terminology

Before we continue, let's clarify some terms:

* `Mock` is a simulated object that mimic the behaviour of real objects in controlled ways. 
* `Mocking` is to use configurable and inspectable functionality, for instance in unit tests. 
* `Registration` is to register return values for a mock function, based on its input arguments.
* `Call/Invoke` is to call a function in a way that records the call, its arguments, the result, etc.
* `Inspection` is to inspect the recorded calls, e.g. to verify that a function has been called, with what arguments, etc.

Let's have a look at how this works in MockingKit.



## Creating a mock

MockingKit lets you create mocks of any protocol or open class, after which you can `call` functions, `register` results, `record` method invocations, and `inspect` recorded calls.

For instance, consider this simple protocol:

```swift
protocol MyProtocol {

    func doStuff(int: Int, string: String) -> String
}
```

With MockingKit, you can easily create a mock implementation of this protocol: 

```swift
import MockingKit

class MyMock: Mock, MyProtocol {

    // Define a lazy reference for each function you want to mock
    lazy var doStuffRef = MockReference(doStuff)

    // Functions must then call the reference to be recorded
    func doStuff(int: Int, string: String) -> String {
        call(doStuffRef, args: (int, string))
    }
}
```

To mock a class, you just have to subclass the class and implement the ``Mockable`` protocol:

```swift
import MockingKit

class MockUserDefaults: UserDefaults, Mockable {

    // You must provide a mock when implementing Mockable
    var mock = Mock()

    // You can now create lazy references just like in the protocol mock above
}
```

``Mock`` is actually just a ``Mockable`` that returns itself as the ``Mockable/mock``.

With a mock in place, you can now start mocking functionality in your unit tests or app.



## Using the mock  

You can now use the mock to `register` function results, `call` functions and `inspect` recorded calls.

```swift
// Create a mock
let mock = MyMock()

// Register a doStuff result
mock.registerResult(for: mock.doStuffRef) { args in String(args.1.reversed()) }

// Calling doStuff will now return the pre-registered result
let result = mock.doStuff(int: 42, string: "string")    // => "gnirts"

// You can now inspect calls made to doStuff
let calls = mock.calls(to: mock.doStuffRef)             // => 1 item
calls[0].arguments.0                                    // => 42
calls[0].arguments.1                                    // => "string"
calls[0].result                                         // => "gnirts"
mock.hasCalled(mock.doStuffRef)                         // => true
mock.hasCalled(mock.doStuffRef, numberOfTimes: 1)       // => true
mock.hasCalled(mock.doStuffRef, numberOfTimes: 2)       // => false
```

For more compact code, you can use keypaths:

```swift
// Create a mock
let mock = MyMock()

// Register a doStuff result
mock.registerResult(for: \.doStuffRef) { args in String(args.1.reversed()) }

// Calling doStuff will now return the pre-registered result
let result = mock.doStuff(int: 42, string: "string")    // => "gnirts"

// You can now inspect calls made to doStuff
let calls = mock.calls(to: \.doStuffRef)                // => 1 item
calls[0].arguments.0                                    // => 42
calls[0].arguments.1                                    // => "string"
calls[0].result                                         // => "gnirts"
mock.hasCalled(\.doStuffRef)                            // => true
mock.hasCalled(\.doStuffRef, numberOfTimes: 1)          // => true
mock.hasCalled(\.doStuffRef, numberOfTimes: 2)          // => false
```

You can configure the mock in any way you want to change the behavior of your tests at any time, call the mock instead of a real implementation (e.g. a network service, a database etc.), and inspect the mock to ensure that your code calls it as expected.



## Important about registering mock function return values

There are some things to consider regarding function return values:

* If a function return value is non-optional, you must register a return value before calling the function. Calling it before registering a return value will cause a crash.
* If a function return value is optional, registering a return value is optional. Calling the function before registering a return value will just return nil and not crash.

You can register new return values at any time, for instance to try many different variations within the same test.


## Multiple function arguments

Since mock arguments are handled as tuples, inspection behaves a bit different if a mocked function has multiple arguments.

For instance, consider a protocol that looks like this:

```swift
protocol MyProtocol {

    func doStuff(int: Int, string: String) -> String
}
```

A MockingKit mock would look like this:

```swift
class MyMock: Mock, MyProtocol {

    lazy var doStuffRef = MockReference(doStuff)

    func doStuff(int: Int, string: String) -> String {
        call(doStuffRef, args: (int, string))
    }
}
```

Since arguments are handled as tuples, you must then use tuple positions to inspect them:

```swift
let mock = MyMock()
mock.registerResult(for: mock.doStuffRef) { args in String(args.1.reversed()) }
let result = mock.doStuff(int: 42, string: "string")    // => "gnirts"
let inv = mock.invokations(of: mock.doStuffRef)         // => 1 item
inv[0].arguments.0                                      // => 42
inv[0].arguments.1                                      // => "message"
```

There is no upper-limit to the number of function arguments you can use in a mocked function.



## Multiple functions with the same name

Mock references require some extra considerations when a mock has multiple functions with the same name.

For instance, consider a protocol that looks like this:

```swift
protocol MyProtocol {

    func doStuff(with int: Int) -> Bool
    func doStuff(with int: Int, string: String) -> String
}
```

You must then specify the function signature when creating the mock references:

```swift
class MyMock: Mock, MyProtocol {

    lazy var doStuffWithIntRef = MockReference(doStuff as (Int) -> Bool)
    lazy var doStuffWithIntAndStringRef = MockReference(doStuff as (Int, String) -> String)

    func doStuff(with int: Int) -> Bool {
        call(doStuffWithInt, args: (int))
    }

    func doStuff(with int: Int, string: String) -> String {
        call(doStuffWithIntAndStringRef, args: (int, string))
    }
}
```

This gives you a unique references for every unique function.



## Properties

Properties can't currently be mocked, since the reference model requires a function. 

If you want to mock properties, you can invoke custom function references in the mock's getter and/or setter.



## Async functions

MockingKit supports Swift concurrency and lets you mock any `async` function.

Mocking `async` functions works exactly like mocking non-async functions. No additional code is required.



## Completion blocks

Functions with completion blocks are just `Void` functions where the completion block is just an argument.

Mocking these kind of functions works exactly like mocking any other functions. No additional code is required. 

You must however manually call the completion from within your mock, if you want them to trigger.
