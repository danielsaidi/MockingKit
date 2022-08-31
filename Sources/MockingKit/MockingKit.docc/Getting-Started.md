# Getting started

This article describes how you get started with MockingKit.


## Terminology

Before we continue, let's clarify what this means in detail.

* `Invokation` is to call a function. In a mock, this records the call and saves information about how many times a function has been called, with which arguments, the returned result etc.
* `Inspection` is to look at recorded invokation and use it e.g. in a unit test. For instance, we can verify that a function has been triggered only once, with certain arguments etc.
* `Registration` is to pre-register a dynamic return value for a function, based on the arguments with which the function is called.

Let's have a look at how this works in MockingKit.



## Creating a mock

MockingKit can be used to mock any protocol or class, for instance when unit testing or mocking not yet implemented functionality.

For instance, say that you have a `MyProtocol` protocol:

```swift
protocol MyProtocol {

    func doStuff(int: Int, string: String) -> String
}
```

You can then create a mock implementation of the protocol by creating a mock class that inherits the ``Mock`` base class and implements `MyProtocol`:

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

If your mock can't inherit ``Mock``, e.g. when mocking structs or inheriting another base class, you can implement the ``Mockable`` protocol instead, by just providing a custom `mock` instance: 

```swift
class MyMock: MyBaseClass, Mockable, MyProtocol {

    let mock = Mock()
    
    // ... the rest is the same. `Mock` just saves you one line of code :)
}
```

``Mock`` is basically just a ``Mockable`` that returns itself as ``Mockable/mock``.

With the mock in place, you can use it to mock functionality in your unit tests or app.



## Using the mock  

You can now use the mock to register function results, call functions and inspect calls:

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

If a return value is optional, it's also optional to register a return value before invoking the function. Calling `invoke` before registering a return value will return `nil`.

If the return value is non-optional, you must register a return value before invoking the function. Calling `invoke` before registering a return value will cause a crash.


## Multiple function arguments

If a mocked function has multiple arguments, inspection behaves a little different, since arguments are handled as tuples.

Say that we have a protocol that looks like this:

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
        invoke(doStuffRef, args: (int, string))
    }
}
```

Since function arguments are handled as tuples, you now use tuple positions to inspect arguments:

```swift
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

There is no upper-limit to the number of function arguments you can use in a mocked function.


## Multiple functions with the same name

If your mock has multiple methods with the same name:

```swift
protocol MyProtocol {

    func doStuff(with int: Int) -> Bool
    func doStuff(with int: Int, string: String) -> String
}
```

your must explicitly specify the function signature when creating references:

```swift
class MyMock: Mock, MyProtocol {

    lazy var doStuffWithIntRef = MockReference(doStuff as (Int) -> Bool)
    lazy var doStuffWithIntAndStringRef = MockReference(doStuff as (Int, String) -> String)

    func doStuff(with int: Int) -> Bool {
        invoke(doStuffWithInt, args: (int))
    }

    func doStuff(with int: Int, string: String) -> String {
        invoke(doStuffWithIntAndStringRef, args: (int, string))
    }
}
```

This is actually nice, since it gives you a unique references for each function. It also makes the unit test code easier to write.



## Properties

In MockingKit, properties can't be mocked with function references, since the function reference model requires a function. To fake the value of a mock property, just set the properties of the mock right away. 

If you however for some reason want to inspect how a property is called, modified etc., you can invoke custom references to private functions in the getter and/or setter.



## Async functions

MockingKit supports Swift concurrency and lets you mock any `async` function.

Mocking `async` functions works exactly like mocking non-async functions. No additional code is required.



## Completion blocks

Functions with completion blocks are just `Void` return functions where the completion block is just arguments like any others.

Mocking these kind of functions works exactly like mocking any other functions. No additional code is required. 

You must however manually call the completions from within your mocks if you want them to trigger.



## Conclusion

That's about it. Enjoy using this library to mock functionality in SwiftUI!
