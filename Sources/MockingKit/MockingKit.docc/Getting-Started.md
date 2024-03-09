# Getting started

This article explains how to get started with MockingKit.

@Metadata {
    
    @PageImage(
        purpose: card,
        source: "Page",
        alt: "Page icon"
    )
    
    @PageColor(blue)
}


## Terminology

Before we start, let's clarify some terms:

* **Mock** is a simulated object that mimic the behaviour of real objects in controlled ways. 
* **Mocking** is to use configurable and inspectable functionality, for instance in unit tests. 
* **Call/Invoke** is calling a function in a way that records the call and its arguments & result.
* **Registration** is to register dynamic return values for a mock function, based on its arguments.
* **Inspection** is to inspect a recorded call, e.g. to verify that it has been called, its arguments, etc.

Let's have a look at how this works in MockingKit.



## Creating a mock

MockingKit lets you mock any protocol or open class, after which you can **call** functions, **register** results, **record** method invocations, and **inspect** recorded calls.

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

To mock a class, you instead have to subclass the class and implement the ``Mockable`` protocol:

```swift
import MockingKit

class MockUserDefaults: UserDefaults, Mockable {

    // You must provide a mock when implementing Mockable
    var mock = Mock()

    // You can now create lazy references just like in the protocol mock above
}
```

``Mock`` is actually just a ``Mockable`` that returns itself as its ``Mockable/mock``.

With the mock in place, you can now start mocking functionality in your unit tests or app.



## Using the mock  

We can now use the mock to register dynamic function results, call mocked functions and inspect all recorded calls. 

The easiest and most compact way to do this is to use keypaths:

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



## Important about registering return values

There are some things to consider when registering mock function return values:

* **Optional** functions will return **nil** if you don't register a return value before calling them.
* **Non-optional** functions will **crash** if you don't register a return value before calling them.

You can register new return values at any time, for instance to try many different return values within the same test or test case.


## Multiple function arguments

Since mock function arguments are handled as tuples, inspection behaves a bit different if a mocked function has multiple arguments.

For instance, consider this protocol:

```swift
protocol MyProtocol {

    func one(_ int: Int) -> String
    func two(_ int: Int, _ string: String) -> String
}
```

A MockingKit mock of this protocol could look like this:

```swift
class MyMock: Mock, MyProtocol {

    lazy var oneRef = MockReference(one)
    lazy var twoRef = MockReference(two)

    func one(_ int: Int) -> String {
        call(oneRef, args: (int, string))
    }

    func two(_ int: Int, _ string: String) -> String {
        call(oneRef, args: (int, string))
    }
}
```

Functions with a single argument can inspect the argument directly, while functions with two or more arguments require inspecting the arguments as tuples:

```swift
let mock = MyMock()
mock.registerResult(for: mock.oneRef) { args in -args }
mock.registerResult(for: mock.twoRef) { args in String(args.1.reversed()) }
let res1 = mock.one(int: 1)                   // => -1
let res2 = mock.two(int: 2, string: "string") // => "gnirts"
let inv1 = mock.calls(to: mock.oneRef)        // => 1 item
let inv2 = mock.calls(to: mock.twoRef)        // => 1 item
inv1[0].arguments                             // => -1
inv2[0].arguments.0                           // => 2
inv2[0].arguments.1                           // => "message"
```

There is no upper-limit to the number of arguments you can use in a mocked function.



## Multiple functions with the same name

Mocked function references require some considerations when protocol or class has multiple functions with the same name.

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

This gives you a unique references for each function, which you can use just like above. The rest works exactly the same. 



## Properties

Properties can't currently be mocked, since the reference model requires a function. 

If you want to mock properties, you can invoke custom function references in the mock's getter and/or setter.



## Async functions

MockingKit supports Swift concurrency and lets you mock any `async` function.

Mocking `async` functions works exactly like mocking non-async functions. No additional code is required.



## Completion blocks

Functions with completion blocks are just `Void` functions where the completion block is just an argument.

Mocking these kind of functions works exactly like mocking any other functions. No additional code is required.
