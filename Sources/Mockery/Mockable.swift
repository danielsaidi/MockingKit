//
//  Mockable.swift
//  Mockery
//
//  Created by Daniel Saidi on 2019-11-25.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented by any mock that should be
 able to record function calls and return any pre-registered
 return values.
 
 To implement this protocol, you must just provide the class
 with a `mock`. If the class doesn't have to inherit another
 class, you can just inherit the `Mock` class instead, which
 implements `Mockable` by using itself as `mock`.
 
 Let's look at how easy it is to create a mock of a protocol.
 Let's say that we have a `Printer` that can print a text:
 
 ```swift
 protocol Printer {
     func print(_ text: String)
 }
 ```
 
 The easiest way to create a mocked `Printer` is to create a
 class that inherits `Mock` and implements `Printer`:
 
 ```swift
 class MockPrinter: Mock, Printer {
 
     lazy var invokeRef = MockReference(invoke)  // Must be lazy
 
     func print(_ text: String) {
         invoke(invokeRef, arguments: (text))
     }
 }
 ```
 
 Note the lazy reference. It's needed to keep track of how a
 mock is used. It must also be lazy so the signature becomes
 correct. Your mock now just have to call `invoke` to record
 the call and return any pre-registered return value, if any.
 
 To use this mock, you just have to create an instance of it
 and use it like you would use any other implementation. You
 can inject it into any class that depends on a `Printer` to
 verify that the class does what it should.

 When the mock calls `invoke`, it basically records the call
 so that you can inspect it later:
 
 ```swift
 let printer = MockPrinter()
 printer.print("Hello!")
 let inv = printer.invokations(of: printer.printRef)    // => 1 item
 inv[0].arguments.0                                     // => "Hello!"
 printer.hasInvoked(printer.printRef)                   // => true
 printer.hasInvoked(printer.printRef, numberOfTimes: 1) // => true
 printer.hasInvoked(printer.printRef, numberOfTimes: 2) // => false
 ```
 
 Note that you call the function, but inspect the reference.
 
 If your mocked function returns a value, you must `register`
 a return value before calling it. `invoke` will then return
 the pre-registered value:
 
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
 
 Make sure to register non-optional results before calling a
 returning function, otherwise your test will crash:
 
 ```swift
 let converter = MockStringConverter()
 let result = converter.convert("banana") // => Crash!
 converter.registerResult(for: convert) { input in input.reversed() }
 let result = converter.convert("banana") // => Returns "ananab"
 ```
 
 You don't have to do this for optional return values, since
 not registering a value will just make them return `nil`.
 
 Note that the result block receives the arguments that were
 used to call the function. This means that you can vary the
 return value depending on the input arguments.
 
 `TODO` For now, this protocol has no error registration for
 functions that do not return a value. This means that async
 functions can't register custom completion errors.
*/
public protocol Mockable {
    
    typealias Function = Any
    
    var mock: Mock { get }
}

// MARK: - Result Registration

public extension Mockable {
    
    func registerResult<Arguments, Result>(
        for ref: MockReference<Arguments, Result>,
        result: @escaping (Arguments) throws -> Result) {
        mock.registeredResults[ref.id] = result
    }
}


// MARK: - Invokes

public extension Mockable {
    
    /**
     Invoke a function that has a non-optional return value.
     
     This will return a registered return value, if any, or
     crash if no return value has been registered.
     
     `IMPORTANT` The class will still compile if this invoke
     function would be removed, but it would cause the other
     invoke functions to call themselves over and over. This
     function is what makes it all work.
    */
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        args: Arguments,
        file: StaticString = #file,
        line: UInt = #line,
        functionCall: StaticString = #function) -> Result {
        
        if Result.self == Void.self {
            let void = unsafeBitCast((), to: Result.self)
            let inv = MockInvokation(arguments: args, result: void)
            registerInvokation(inv, for: ref)
            return void
        }
        
        let resultBlock = mock.registeredResults[ref.id] as? (Arguments) throws -> Result
        guard let result = try? resultBlock?(args) else {
            let message = "You must register a result for '\(functionCall)' with `registerResult(for:)` before calling this function."
            preconditionFailure(message, file: file, line: line)
        }
        let inv = MockInvokation(arguments: args, result: result)
        registerInvokation(inv, for: ref)
        return result
    }
    
    /**
     Invoke a function that has a non-optional return value,
     using a fallback value if no value has been registered.
     
     This function will return a registered return value or
     the provided fallback if no value has been registered.
    */
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        args: Arguments,
        fallback: @autoclosure () -> Result) -> Result {
        let closure = mock.registeredResults[ref.id] as? (Arguments) throws -> Result
        let result = (try? closure?(args)) ?? fallback()
        registerInvokation(MockInvokation(arguments: args, result: result), for: ref)
        return result
    }
    
    /**
     Invoke a function that has a non-optional return value,
     using a fallback value if no value has been registered.
     
     This will return a registered return value, if any, or
     the provided fallback if no result has been registered.
    */
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        args: Arguments!,
        fallback: @autoclosure () -> Result) throws -> Result {
        try invoke(ref, args: args, fallback: fallback())
    }

    /**
     Invoke a function that has an optional return value.
     
     This will return a registered return value, if any, or
     `nil` if no return value has been registered.
    */
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result?>,
        args: Arguments) -> Result? {
        let closure = mock.registeredResults[ref.id] as? (Arguments) throws -> Result?
        let result = try? closure?(args)
        registerInvokation(MockInvokation(arguments: args, result: result), for: ref)
        return result
    }
    
    /**
     Invoke a function that has an optional return value.
     
     This will return a registered return value, if any, or
     `nil` if no return value has been registered.
    */
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result?>,
        args: Arguments!) throws -> Result? {
        try invoke(ref, args: args)
    }
    
    /**
     Invoke a function that has a non-optional return value.
     
     This will return a registered return value, if any, or
     crash if no return value has been registered.
    */
    func invokeAsync<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        args: Arguments!,
        file: StaticString = #file,
        line: UInt = #line,
        functionCall: StaticString = #function) -> Result {
        invoke(ref, args: args, file: file, line: line, functionCall: functionCall)
    }
    
    /**
     Reset all registered invokations.
     */
    func resetInvokations() {
        mock.registeredInvokations = [:]
    }
    
    /**
     Reset all registered invokations.
     */
    func resetInvokations<Arguments, Result>(
        for ref: MockReference<Arguments, Result>) {
        mock.registeredInvokations[ref.id] = []
    }
}


// MARK: - Inspection

public extension Mockable {
    
    func invokations<Arguments, Result>(
        of ref: MockReference<Arguments, Result>) -> [MockInvokation<Arguments, Result>] {
        registeredInvokations(for: ref)
    }
    
    func hasInvoked<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>) -> Bool {
        invokations(of: ref).count > 0
    }
    
    func hasInvoked<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        numberOfTimes: Int) -> Bool {
        invokations(of: ref).count == numberOfTimes
    }
}


// MARK: - Private Functions

private extension Mockable {
    
    /**
     Register a function invokation at a memory address.
     */
    func registerInvokation<Arguments, Result>(
        _ invokation: MockInvokation<Arguments, Result>,
        for ref: MockReference<Arguments, Result>) {
        let invokations = mock.registeredInvokations[ref.id] ?? []
        mock.registeredInvokations[ref.id] = invokations + [invokation]
    }
    
    /**
     Get all registered function invokation for a certain memory address.
    */
    func registeredInvokations<Arguments, Result>(
        for ref: MockReference<Arguments, Result>) -> [MockInvokation<Arguments, Result>] {
        let invokation = mock.registeredInvokations[ref.id]
        return (invokation as? [MockInvokation<Arguments, Result>]) ?? []
    }
}
