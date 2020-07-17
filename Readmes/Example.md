#  Example

To create a mock, you just have to implement `Mockable`, which is the main protocol in `Mockery`. It lets your class record function calls and return any pre-registered return values.

If your mock doesn't have to inherit another class (which is needed when mocking classes, e.g. `UserDefaults`), you can just inherit `Mock`, which implements `Mockable` by using itself as a mock.


## Invoking function calls

Let's look at how easy it is to create a mock. Let's say that we have a `Printer` protocol:

```swift
protocol Printer {
    func print(_ text: String)
}
```

To create a mocked `Printer`, you just have to inherit `Mock` and implement `Printer` like this:

```swift
class MockPrinter: Mock, Printer {

    lazy var invokeRef = MockReference(invoke)  // Must be lazy

    func print(_ text: String) {
        invoke(invokeRef, arguments: (text))
    }
}
```

Note the lazy reference (it must be lazy for the signature to become correct), which is needed to keep track of how the mock is used.


## Inspect invokations

When a mock calls `invoke`, it basically records the call so that you can inspect it later:

```swift
let printer = MockPrinter()
printer.print("Hello!")
let inv = printer.invokations(of: printer.printRef)     // => 1 item
inv[0].arguments.0                                      // => "Hello!"
printer.hasInvoked(printer.printRef)                    // => true
printer.hasInvoked(printer.printRef, numberOfTimes: 1)  // => true
printer.hasInvoked(printer.printRef, numberOfTimes: 2)  // => false
```

Note how you call the function as normal, then use the reference to inspect the mock.


## Return values

If your mocked function returns a value, you can register a return value with `registerResult(for:result:)`. `invoke` will then return the pre-registered value:

```swift
protocol Converter {
    func convert(_ text: String) -> String
}

class MockConverter: Mock, Converter {

    lazy var convertRef = MockReference(convert)

    func convert(_ text: String) -> String {
        invoke(convertRef, arguments: (text))
    }
}
```

If your function returns a non-optional result, you must register a return value before calling it. If you don't, Mockery will intentionally crash with a precondition failure.

```swift
let converter = MockStringConverter()
let result = converter.convert("banana") // => Crash!
converter.registerResult(for: convert) { input in input.reversed() }
let result = converter.convert("banana") // => Returns "ananab"
```

This is not needed for optional return values. Not registering a value before calling the function will just make the function return `nil`.

Note how the result block takes the same arguments as the actual function. This means that you can vary the return value depending on the input arguments.


[Quick]: https://github.com/Quick/Quick
[Nimble]: https://github.com/Quick/Nimble