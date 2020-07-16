//
//  Mockable.swift
//  Mockery
//
//  Created by Daniel Saidi on 2019-11-25.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol represents any mockable test class and can be
 used to record function calls and return any pre-registered
 return values.
 
 When you implement this protocol, you must provide a `mock`.
 If a mock does not have to inherit another class, it should
 inherit `Mock`, since it implements `Mockable` by providing
 itself as the mock:
 
 ```swift
 protocol Printer {
    func print(_ text: String)
 }
 
 // Inherit `Mock` if you don't have to inherit a base class
 class MockPrinter: Mock, Printer {
    func print(_ text: String) {
        invoke(print, arguments: (text))
    }
 }
 
 // Implement `Mockable` if you have to inherit a base class
 class MockPrinter: BasePrinter, Mockable {
    let mock = Mock()
    func print(_ text: String) {
        invoke(print, arguments: (text))
    }
 }
 ```

 Calling `invoke` records functions calls so you can inspect
 them later:
 
 ```swift
 let printer = MockPrinter()
 printer.print("Hello!")
 let invokations = printer.invokations(of: printer.print)   // => 1 item
 invokations[0].arguments.0                                 // => "Hello!"
 printer.hasInvoked(printer.print)                          // => true
 printer.hasInvoked(printer.print, numberOfTimes: 1)        // => true
 printer.hasInvoked(printer.print, numberOfTimes: 2)        // => false
 ```
 
 You can use `invoke` in the same way for void functions and
 for functions that return a result. For returning functions,
 `invoke` will return any pre-registered return value:
 
 ```swift
 protocol Converter {
     func convert(_ text: String) -> String
 }
 
 class MockConverter: Mock, Converter {
     func convert(_ text: String) -> String {
         invoke(convert, arguments: (text))
     }
 }
 ```
 
 Make sure to register non-optional results before calling a
 returning function, or it will crash when it's being called:
 
 ```swift
 let converter = MockStringConverter()
 let result = converter.convert("banana")                   // => Crash!
 converter.registerResult(for: convert) { input in input.reversed() }
 let result = converter.convert("banana")                   // => Returns "ananab"
 ```
 
 Since the result block is called with the original argument
 collection, you can vary the result based on the arguments.
 
 `TODO` For now, this protocol has no error registration for
 functions that do not return a value. This means that async
 functions can't register custom completion errors.
 
 `TODO` The function address approach doesn't work when your
 mock class is defined in another target than the test.
*/
public protocol Mockable {
    
    typealias Function = Any
    
    var mock: Mock { get }
}

// MARK: - Result Registration

public extension Mockable {
    
    func registerResult<Arguments, Result>(
        for function: @escaping (Arguments) throws -> Result,
        resultBlock: @escaping (Arguments) throws -> Result) {
        let address = self.address(of: function)
        mock.registeredResults[UUID()] = resultBlock
    }
}


// MARK: - Invokes

public extension Mockable {
    
    /**
     Invoke a function that has a non-optional return value.
     
     This will return a registered return value, if any, or
     crash if no return value has been registered.
    */
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments,
        file: StaticString = #file,
        line: UInt = #line,
        functionCall: StaticString = #function) rethrows -> Result {
        let address = self.address(of: function)
        
        if Result.self == Void.self {
            let void = unsafeBitCast((), to: Result.self)
            register(MockInvokation(arguments: args, result: void), at: address)
            return void
        }
        
        let closure = mock.registeredResults[UUID()] as? (Arguments) throws -> Result
        guard let result = try? closure?(args) else {
            let message = """
            '\(functionCall)' has no registered result.
            You must register one with `registerResult(for:)` before calling this function.
            """
            preconditionFailure(message, file: file, line: line)
        }
        register(MockInvokation(arguments: args, result: result), at: address)
        return result
    }
    
    /**
     Invoke a function that has a non-optional return value.
     
     This will return a registered return value, if any, or
     crash if no return value has been registered.
    */
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments!,
        file: StaticString = #file,
        line: UInt = #line,
        functionCall: StaticString = #function) rethrows -> Result {
        try invoke(function, args: args, file: file, line: line, functionCall: functionCall)
    }
    
    /**
     Invoke a function that has a non-optional return value,
     using a fallback value if no value has been registered.
     
     This function will return a registered return value or
     the provided fallback if no value has been registered.
    */
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments,
        fallback: @autoclosure () -> Result) rethrows -> Result {
        let address = self.address(of: function)
        let closure = mock.registeredResults[UUID()] as? (Arguments) throws -> Result
        let result = (try? closure?(args)) ?? fallback()
        register(MockInvokation(arguments: args, result: result), at: address)
        return result
    }
    
    /**
     Invoke a function that has a non-optional return value,
     using a fallback value if no value has been registered.
     
     This will return a registered return value, if any, or
     the provided fallback if no result has been registered.
    */
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments!,
        fallback: @autoclosure () -> Result) rethrows -> Result {
        try invoke(function, args: args, fallback: fallback())
    }

    /**
     Invoke a function that has an optional return value.
     
     This will return a registered return value, if any, or
     `nil` if no return value has been registered.
    */
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result?,
        args: Arguments) rethrows -> Result? {
        let address = self.address(of: function)
        let closure = mock.registeredResults[UUID()] as? (Arguments) throws -> Result?
        let result = try? closure?(args)
        register(MockInvokation(arguments: args, result: result), at: address)
        return result
    }
    
    /**
     Invoke a function that has an optional return value.
     
     This will return a registered return value, if any, or
     `nil` if no return value has been registered.
    */
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result?,
        args: Arguments!) rethrows -> Result? {
        try invoke(function, args: args)
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
    func resetInvokations<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) {
        mock.registeredInvokations[UUID()] = []
    }
}


// MARK: - Inspection

public extension Mockable {
    
    func invokations<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> [MockInvokation<Arguments, Result>] {
        registeredInvokations(at: address(of: function))
    }
    
    func hasInvoked<Arguments, Result>(_ function: @escaping (Arguments) throws -> Result) -> Bool {
        invokations(of: function).count > 0
    }
    
    func hasInvoked<Arguments, Result>(_ function: @escaping (Arguments) throws -> Result, numberOfTimes: Int) -> Bool {
        invokations(of: function).count == numberOfTimes
    }
}


// MARK: - Private Functions

private extension Mockable {
    
    /**
     Register a function invokation at a memory address.
     */
    func register<Arguments, Result>(_ invokation: MockInvokation<Arguments, Result>, at address: MemoryAddress) {
        mock.registeredInvokations[UUID()] = (mock.registeredInvokations[UUID()] ?? []) + [invokation]
    }
    
    /**
     Get all registered function invokation for a certain memory address.
    */
    func registeredInvokations<Arguments, Result>(at address: MemoryAddress) -> [MockInvokation<Arguments, Result>] {
        return (mock.registeredInvokations[UUID()] as? [MockInvokation<Arguments, Result>]) ?? []
    }
}
