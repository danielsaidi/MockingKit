#  Example

To create a mock in MockingKit, you either:

* Inherit `Mock` and implement any protocol that you want to mock.
* Implement `Mockable` and inherit any class that you want to mock.

`Mock` is basically just a `Mockable` implementation that returns itself as `mock`.  You can use it as long as the mock doesn't have to inherit another class.

Mocks can register return values, record function calls and inspect how functions have been called. 


## Calling mocked functions

Let's look at how to create a mock. Let's say that we have a `Printer` protocol:

```swift
protocol Printer {

    func print(_ text: String)
}
```

To create a mocked `Printer`, just inherit `Mock` and implement `Printer` like this:

```swift
class MockPrinter: Mock, Printer {

    lazy var printRef = MockReference(print)  // References must be lazy

    func print(_ text: String) {
        call(printRef, args: (text))
    }
}
```

In the code above, we create a `function reference`, which is used as a pointer to the function. You use these references when you register function results and inspect function calls.

Note the `lazy` reference! Function references must be lazy for the signature to become correct.


## Inspecting function calls

When a mock receives a `call`, it records the call so you can inspect it later:

```swift
let printer = MockPrinter()
printer.print("Hello!")
let calls = printer.calls(to: printer.printRef)         // => 1 item
calls[0].arguments                                      // => "Hello!"
printer.hasCalled(printer.printRef)                     // => true
printer.hasCalled(printer.printRef, numberOfTimes: 1)   // => true
printer.hasCalled(printer.printRef, numberOfTimes: 2)   // => false
```

Note how you call the function as normal, then use the reference to inspect the mock.


## Registering function results

You can pre-register function results before calling your mock:

* Functions that don't return anything doesn't support registering a return value.
* Functions that returns an `optional` result don't require you to register a value before using  `call`.
* Functions that returns a `non-optional` result requires you to register a value before using  `call`.

You register return values with `registerResult(for:result:)`:

```swift
protocol Converter {

    func convert(_ text: String) -> String
    func tryConvert(_ text: String) -> String?
}

class MockConverter: Mock, Converter {

    lazy var convertRef = MockReference(convert)
    lazy var tryConvertRef = MockReference(tryConvert)

    func convert(_ text: String) -> String {
        call(convertRef, args: (text))
    }
    
    func tryConvert(_ text: String) -> String? {
        call(tryConvertRef, args: (text))
    }
}

let converter = MockConverter()

converter.tryConvert("banana") // => nil
converter.registerResult(for: converter.tryConvertRef) { input in String(input.reversed()) }
converter.tryConvert("banana") // => "ananab"

converter.convert("banana") // => Crash!
converter.registerResult(for: converter.convertRef) { input in String(input.reversed()) }
converter.convert("banana") // => "ananab"
```

Note how the result block takes the same arguments as the actual function. This means that you can vary the return value depending on the input arguments.
