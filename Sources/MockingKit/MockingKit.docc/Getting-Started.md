# Getting started

This article describes how you get started with MockingKit.


## Terminology

Before we continue, let's clarify some terms and what they mean.

* `Mocking` is to replace functionality with a configurable and inspectable replacement, for instance when writing unit tests. 
* `Registration` is to register a dynamic return value for a mock function, based on its input arguments.
* `Call` is to call a mock function in a way that records how many times it has been called, with which arguments, its result etc.
* `Inspection` is to look at recorded calls, e.g. to verify that a function has been called as expected, with expected arguments etc.

Let's have a look at how this works in MockingKit.



## Creating a mock

MockingKit can be used to mock any protocol or class, for instance when unit testing or to fake not yet implemented functionality.

For instance, say that you have this protocol:

```swift
protocol MyProtocol {

    func doStuff(int: Int, string: String) -> String
}
```

You can now create a mock implementation of the protocol by creating a class that inherits the ``Mock`` class and implements `MyProtocol`:

```swift
class MyMock: Mock, MyProtocol {

    // You have to define a lazy reference for each function you want to mock
    lazy var doStuffRef = MockReference(doStuff)

    // Functions must then call the reference to be recorded
    func doStuff(int: Int, string: String) -> String {
        call(doStuffRef, args: (int, string))
    }
}
```

If you can't inherit ``Mock``, e.g. when mocking structs or inheriting another class like `NotificationCenter`, you can implement the ``Mockable`` protocol instead.

``Mockable`` works just like ``Mock``, but requires that you provide a ``Mockable/mock`` property: 

```swift
class MyMock: MyBaseClass, Mockable, MyProtocol {

    let mock = Mock()
    
    // ... the rest is the same. `Mock` just saves you one line of code :)
}
```

``Mock`` is actually just a ``Mockable`` that returns itself as the ``Mockable/mock``.

With the mock in place, you can use it to mock functionality in your unit tests or app.



## Using the mock  

You can now use the mock to register function results, call functions and inspect calls:

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

For more compact code, you can use keypaths to avoid having to specify the mock twice:

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

This lets you provide mock implementations instead of real ones when unit testing your code. You can configure the mock in any way you want to change the behavior of your tests, call the mock instead of a real implementation (e.g. a network service, a database etc.) and then inspect the mock to ensure that your code calls the mock as you expect it to.



## Important about registering mock function return values

If a function's return value is non-optional, you must register a return value before calling the function. Calling the function before registering a return value will cause a runtime crash.

If a function's return value is optional, it's also optional to register a return value before calling the function. Calling the function before registering a return value will just return `nil`.



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
        call(doStuffRef, args: (int, string))
    }
}
```

Since function arguments are handled as tuples, you must then use tuple positions to inspect arguments:

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

Consider a case where a mock has multiple methods with the same name:

```swift
protocol MyProtocol {

    func doStuff(with int: Int) -> Bool
    func doStuff(with int: Int, string: String) -> String
}
```

You must then specify the function signature when creating a mock reference:

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

This gives you a unique references for each unique function.



## Properties

Properties can't currently be mocked with MockingKit, since the reference model requires a function. 

If you want to inspect how a property is called, you can invoke custom function references in the mock's getter and/or setter.



## Async functions

MockingKit supports Swift concurrency and lets you mock any `async` function.

Mocking `async` functions works exactly like mocking non-async functions. No additional code is required.



## Completion blocks

Functions with completion blocks are just `Void` return functions where the completion block is just arguments like any others.

Mocking these kind of functions works exactly like mocking any other functions. No additional code is required. 

You must however manually call the completions from within your mocks if you want them to trigger.



## Conclusion

That's about it. Enjoy using this library to mock functionality in Swift!
