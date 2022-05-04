//
//  Mockable.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-11-25.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented by any type that should be
 used as a mock, e.g. when unit testing.
 
 To implement the protocol, just provide a ``mock`` property:
 
 ```
 class MyMock: Mockable {
 
     let mock = Mock()
 }
 ```
 
 You can then use it to register function results, call mock
 functions (which are recorded) and inspect function calls.
 
 Only implement the protocol when you can't inherit ``Mock``,
 e.g. when mocking structs or when a mock class must inherit
 a base class, e.g. when mocking classes like `UserDefaults`.
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

    /**
     Register a result value for a certain mocked async function.
     */
    func registerResult<Arguments, Result>(
        for ref: AsyncMockReference<Arguments, Result>,
        result: @escaping (Arguments) async throws -> Result) {
        mock.registeredResults[ref.id] = result
    }
}


// MARK: - Calls

public extension Mockable {
    
    /**
     Call a function with a `non-optional` result. This will
     return a pre-registered result or crash if no result is
     registered.
    */
    func call<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        args: Arguments,
        file: StaticString = #file,
        line: UInt = #line,
        functionCall: StaticString = #function) -> Result {
        
        if Result.self == Void.self {
            let void = unsafeBitCast((), to: Result.self)
            let call = MockCall(arguments: args, result: void)
            registerCall(call, for: ref)
            return void
        }
        
        guard let result = try? registeredResult(for: ref)?(args) else {
            let message = "You must register a result for '\(functionCall)' with `registerResult(for:)` before calling this function."
            preconditionFailure(message, file: file, line: line)
        }
        let call = MockCall(arguments: args, result: result)
        registerCall(call, for: ref)
        return result
    }

    /**
     Call an async function with a `non-optional` result. This will
     return a pre-registered result or crash if no result is
     registered.
    */
    func call<Arguments, Result>(
        _ ref: AsyncMockReference<Arguments, Result>,
        args: Arguments,
        file: StaticString = #file,
        line: UInt = #line,
        functionCall: StaticString = #function) async -> Result {

        if Result.self == Void.self {
            let void = unsafeBitCast((), to: Result.self)
            let call = MockCall(arguments: args, result: void)
            registerCall(call, for: ref)
            return void
        }

            guard let result = try? await registeredResult(for: ref)?(args) else {
            let message = "You must register a result for '\(functionCall)' with `registerResult(for:)` before calling this function."
            preconditionFailure(message, file: file, line: line)
        }
        let call = MockCall(arguments: args, result: result)
        registerCall(call, for: ref)
        return result
    }
    
    /**
     Call a function with a `non-optional` result. This will
     return a pre-registered result or a `fallback` value if
     no result has been registered.
    */
    func call<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        args: Arguments,
        fallback: @autoclosure () -> Result) -> Result {
        let result = (try? registeredResult(for: ref)?(args)) ?? fallback()
        registerCall(MockCall(arguments: args, result: result), for: ref)
        return result
    }

    /**
     Call an async function with a `non-optional` result. This will
     return a pre-registered result or a `fallback` value if
     no result has been registered.
    */
    func call<Arguments, Result>(
        _ ref: AsyncMockReference<Arguments, Result>,
        args: Arguments,
        fallback: @autoclosure () -> Result) async -> Result {
        let result = (try? await registeredResult(for: ref)?(args)) ?? fallback()
        registerCall(MockCall(arguments: args, result: result), for: ref)
        return result
    }
    
    /**
     Call a function with an `optional` result. This returns
     a pre-registered result or `nil`.
    */
    func call<Arguments, Result>(
        _ ref: MockReference<Arguments, Result?>,
        args: Arguments) -> Result? {
        let result = try? registeredResult(for: ref)?(args)
        registerCall(MockCall(arguments: args, result: result), for: ref)
        return result
    }

    /**
     Call an async function with an `optional` result. This returns
     a pre-registered result or `nil`.
    */
    func call<Arguments, Result>(
        _ ref: AsyncMockReference<Arguments, Result?>,
        args: Arguments) async -> Result? {
        let result = try? await registeredResult(for: ref)?(args)
        registerCall(MockCall(arguments: args, result: result), for: ref)
        return result
    }
    
    /**
     Reset all registered calls.
     */
    func resetCalls() {
        mock.registeredCalls = [:]
    }
    
    /**
     Reset all registered calls to a certain function.
     */
    func resetCalls<Arguments, Result>(
        to ref: MockReference<Arguments, Result>) {
        mock.registeredCalls[ref.id] = []
    }

    /**
     Reset all registered calls to a certain asnyc function.
     */
    func resetCalls<Arguments, Result>(
        to ref: AsyncMockReference<Arguments, Result>) {
        mock.registeredCalls[ref.id] = []
    }
}


// MARK: - Inspection

public extension Mockable {
    
    /**
     Get all calls to a certain function.
     */
    func calls<Arguments, Result>(
        to ref: MockReference<Arguments, Result>) -> [MockCall<Arguments, Result>] {
        registeredCalls(for: ref)
    }

    /**
     Get all calls to a certain async function.
     */
    func calls<Arguments, Result>(
        to ref: AsyncMockReference<Arguments, Result>) -> [MockCall<Arguments, Result>] {
        registeredCalls(for: ref)
    }
    
    /**
     Check if a function has been called.
     */
    func hasCalled<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>) -> Bool {
        calls(to: ref).count > 0
    }

    /**
     Check if an async function has been called.
     */
    func hasCalled<Arguments, Result>(
        _ ref: AsyncMockReference<Arguments, Result>) -> Bool {
        calls(to: ref).count > 0
    }
    
    /**
     Check if a function has been called a number of times.
     */
    func hasCalled<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>, numberOfTimes: Int) -> Bool {
        calls(to: ref).count == numberOfTimes
    }

    /**
     Check if an async function has been called a number of times.
     */
    func hasCalled<Arguments, Result>(
        _ ref: AsyncMockReference<Arguments, Result>, numberOfTimes: Int) -> Bool {
        calls(to: ref).count == numberOfTimes
    }
}


// MARK: - Private Functions

private extension Mockable {

    func registerCall<Arguments, Result>(
        _ call: MockCall<Arguments, Result>,
        for ref: MockReference<Arguments, Result>) {
        let calls = mock.registeredCalls[ref.id] ?? []
        mock.registeredCalls[ref.id] = calls + [call]
    }

    func registerCall<Arguments, Result>(
        _ call: MockCall<Arguments, Result>,
        for ref: AsyncMockReference<Arguments, Result>) {
        let calls = mock.registeredCalls[ref.id] ?? []
        mock.registeredCalls[ref.id] = calls + [call]
    }
    
    func registeredCalls<Arguments, Result>(
        for ref: MockReference<Arguments, Result>) -> [MockCall<Arguments, Result>] {
        let calls = mock.registeredCalls[ref.id]
        return (calls as? [MockCall<Arguments, Result>]) ?? []
    }

    func registeredCalls<Arguments, Result>(
        for ref: AsyncMockReference<Arguments, Result>) -> [MockCall<Arguments, Result>] {
        let calls = mock.registeredCalls[ref.id]
        return (calls as? [MockCall<Arguments, Result>]) ?? []
    }

    func registeredResult<Arguments, Result>(
        for ref: MockReference<Arguments, Result>) -> ((Arguments) throws -> Result)? {
        mock.registeredResults[ref.id] as? (Arguments) throws -> Result
    }

    func registeredResult<Arguments, Result>(
        for ref: AsyncMockReference<Arguments, Result>) -> ((Arguments) async throws -> Result)? {
        mock.registeredResults[ref.id] as? (Arguments) async throws -> Result
    }
}
