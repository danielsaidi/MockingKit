#  Example

To create a mock in MockingKit, you just have to inherit `Mock` and implement any protocol tha you want to mock.

`Mock` can record function calls, return any pre-registered return values and inspect how it's mocked functions have been called.

If your mock has to inherit another class (e.g. when mocking `UserDefaults`), you can just implement `Mockable` instead and provide a custom `mock`. `Mock` is basically just a `Mockable` that returns itself as `mock`.


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

    lazy var printRef = MockReference(print)  // Must be lazy

    func print(_ text: String) {
        invoke(printRef, args: (text))
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
inv[0].arguments                                        // => "Hello!"
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
        invoke(convertRef, args: (text))
    }
}
```

If your function returns a non-optional result, you must register a return value before calling it. If you don't, MockingKit is a Swift mocking library that makes it easy to mock protocol implementations for unit tests and not yet implemented functionality. will intentionally crash with a precondition failure.

```swift
let mock = MockConverter()
let result = mock.convert("banana") // => Crash!
converter.registerResult(for: mock.convertRef) { input in String(input.reversed()) }
let result = mock.convert("banana") // => Returns "ananab"
```

This is not needed for optional return values. Not registering a value before calling the function will just make the function return `nil`.

Note how the result block takes the same arguments as the actual function. This means that you can vary the return value depending on the input arguments.
