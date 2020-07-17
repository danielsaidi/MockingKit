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
*/
public protocol Mockable {
    
    typealias Function = Any
    
    var mock: Mock { get }
}


// MARK: - Registration

public extension Mockable {
    
    /**
     Register a result value for a certain mocked function.
     */
    func registerResult<Arguments, Result>(
        for ref: MockReference<Arguments, Result>,
        result: @escaping (Arguments) throws -> Result) {
        mock.registeredResults[ref.id] = result
    }
}


// MARK: - Invokation

public extension Mockable {
    
    /**
     Invoke a function with a `non-optional` result. It will
     return any pre-registered result, or crash if no result
     has been registered.
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
        
        guard let result = try? registeredResult(for: ref)?(args) else {
            let message = "You must register a result for '\(functionCall)' with `registerResult(for:)` before calling this function."
            preconditionFailure(message, file: file, line: line)
        }
        let inv = MockInvokation(arguments: args, result: result)
        registerInvokation(inv, for: ref)
        return result
    }
    
    /**
     Invoke a function with a `non-optional` result. It will
     return any pre-registered result, or return a `fallback`
     value if no result has been registered.
    */
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        args: Arguments,
        fallback: @autoclosure () -> Result) -> Result {
        let result = (try? registeredResult(for: ref)?(args)) ?? fallback()
        registerInvokation(MockInvokation(arguments: args, result: result), for: ref)
        return result
    }
    
    /**
     Invoke a function with a `non-optional` result. It will
     return any pre-registered result, or return a `fallback`
     value if no result has been registered.
    */
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        args: Arguments!,
        fallback: @autoclosure () -> Result) throws -> Result {
        try invoke(ref, args: args, fallback: fallback())
    }

    /**
     Invoke a function with an `optional` result. It returns
     any pre-registered result, or `nil`.
    */
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result?>,
        args: Arguments) -> Result? {
        let result = try? registeredResult(for: ref)?(args)
        registerInvokation(MockInvokation(arguments: args, result: result), for: ref)
        return result
    }
    
    /**
     Invoke a function with an `optional` result. It returns
     any pre-registered result, or `nil`.
    */
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result?>,
        args: Arguments!) throws -> Result? {
        try invoke(ref, args: args)
    }
    
    /**
     Reset all registered invokations.
     */
    func resetInvokations() {
        mock.registeredInvokations = [:]
    }
    
    /**
     Reset all registered invokations for a certain function.
     */
    func resetInvokations<Arguments, Result>(
        for ref: MockReference<Arguments, Result>) {
        mock.registeredInvokations[ref.id] = []
    }
}


// MARK: - Inspection

public extension Mockable {
    
    /**
     Get all invokations of a certain function.
     */
    func invokations<Arguments, Result>(
        of ref: MockReference<Arguments, Result>) -> [MockInvokation<Arguments, Result>] {
        registeredInvokations(for: ref)
    }
    
    /**
     Check if a function has been invoked.
     */
    func hasInvoked<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>) -> Bool {
        invokations(of: ref).count > 0
    }
    
    /**
     Check if a function has been invoked a certain number
     of times.
     */
    func hasInvoked<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        numberOfTimes: Int) -> Bool {
        invokations(of: ref).count == numberOfTimes
    }
}


// MARK: - Private Functions

private extension Mockable {
    
    func registerInvokation<Arguments, Result>(
        _ invokation: MockInvokation<Arguments, Result>,
        for ref: MockReference<Arguments, Result>) {
        let invokations = mock.registeredInvokations[ref.id] ?? []
        mock.registeredInvokations[ref.id] = invokations + [invokation]
    }
    
    func registeredInvokations<Arguments, Result>(
        for ref: MockReference<Arguments, Result>) -> [MockInvokation<Arguments, Result>] {
        let invokation = mock.registeredInvokations[ref.id]
        return (invokation as? [MockInvokation<Arguments, Result>]) ?? []
    }
    
    func registeredResult<Arguments, Result>(
        for ref: MockReference<Arguments, Result>) -> ((Arguments) throws -> Result)? {
        mock.registeredResults[ref.id] as? (Arguments) throws -> Result
    }
}
