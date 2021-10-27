# ``MockingKit``

MockingKit is a Swift-based mocking library that makes it easy to mock protocols and classes. It lets you `register` function results, `call` functions and `inspect` calls.


## Getting started

MockingKit can be used to mock any protocol or class.

For instance, say that you have a `MyProtocol` protocol:


```swift
protocol MyProtocol {
    func doStuff(int: Int, string: String) -> String
}
```

You can then create a mock implementation of the protocol by creating a mock class that inherits the `Mock` base class and implements `MyProtocol`:

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

If your mock can't inherit `Mock`, e.g. when mocking structs or when the mock must inherit another base class, you can implement the `Mockable` protocol by just providing a custom `mock` instance: 

```swift
class MyMock: MyBaseClass, Mockable, MyProtocol {

    let mock = Mock()
    
    // ... the rest is the same. `Mock` just saves you one line of code :)
}
```

You can now use the mock to `register` function results, `call` functions and `inspect` calls:

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

This can be used when unit testing, mock not yet implemented functionality etc.


## Topics

### Mocks

- ``Mock``
- ``Mockable``
- ``MockCall``
- ``MockReference``

### Foundation Mocks

- ``MockNotificationCenter``
- ``MockUserDefaults``

### UIKit Mocks

- ``MockPasteboard``
- ``MockTextDocumentProxy``
