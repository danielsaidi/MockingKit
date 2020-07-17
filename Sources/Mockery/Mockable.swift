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
 
 To see examples of how to use this protocol, please see the
 main readme and the more detailed `Mockable.md`.
 
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
