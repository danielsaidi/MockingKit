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
     Register a result value for a mock reference.

     - Parameters:
       - ref: The mock reference to register a result for.
       - result: What to return when the function is called.
     */
    func registerResult<Arguments, Result>(
        for ref: MockReference<Arguments, Result>,
        result: @escaping (Arguments) throws -> Result) {
        mock.registeredResults[ref.id] = result
    }

    /**
     Register a result value for an async mock reference.

     - Parameters:
       - ref: The mock reference to register a result for.
       - result: What to return when the function is called.
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
     Call a mock reference with `non-optional` result.

     This will return any pre-registered result, or crash if
     no result has been registered.

     Note that this function should only be used by the mock
     itself and not called from the outside.

     - Parameters:
       - ref: The mock reference to call.
       - args: The arguments to call the functions with.
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
     Call an async mock reference with `non-optional` result.

     This will return any pre-registered result, or crash if
     no result has been registered.

     Note that this function should only be used by the mock
     itself and not called from the outside.

     - Parameters:
       - ref: The mock reference to call.
       - args: The arguments to call the functions with.
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
     Call a mock reference with `non-optional` result.

     This will return a pre-registered result or a `fallback`
     value if no result has been registered.

     Note that this function should only be used by the mock
     itself and not called from the outside.

     - Parameters:
       - ref: The mock reference to call.
       - args: The arguments to call the functions with.
       - fallback: The value to return if no result has been registered.
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
     Call an async mock reference with `non-optional` result.

     This will return a pre-registered result or a `fallback`
     value if no result has been registered.

     Note that this function should only be used by the mock
     itself and not called from the outside.

     - Parameters:
       - ref: The mock reference to call.
       - args: The arguments to call the functions with.
       - fallback: The value to return if no result has been registered.
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
     Call a mock reference with `optional` result.

     This will return a pre-registered result or `nil` if no
     result has been registered.

     Note that this function should only be used by the mock
     itself and not called from the outside.

     - Parameters:
       - ref: The mock reference to call.
       - args: The arguments to call the functions with.
    */
    func call<Arguments, Result>(
        _ ref: MockReference<Arguments, Result?>,
        args: Arguments) -> Result? {
        let result = try? registeredResult(for: ref)?(args)
        registerCall(MockCall(arguments: args, result: result), for: ref)
        return result
    }

    /**
     Call an async mock reference with `optional` result.

     This will return a pre-registered result or `nil` if no
     result has been registered.

     Note that this function should only be used by the mock
     itself and not called from the outside.

     - Parameters:
       - ref: The mock reference to call.
       - args: The arguments to call the functions with.
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
     Reset all registered calls for a mock reference.

     - Parameters:
       - ref: The mock reference to reset any calls for.
     */
    func resetCalls<Arguments, Result>(
        to ref: MockReference<Arguments, Result>) {
        mock.registeredCalls[ref.id] = []
    }

    /**
     Reset all registered calls for an async mock reference.

     - Parameters:
       - ref: The mock reference to reset any calls for.
     */
    func resetCalls<Arguments, Result>(
        to ref: AsyncMockReference<Arguments, Result>) {
        mock.registeredCalls[ref.id] = []
    }
}


// MARK: - Inspection

public extension Mockable {
    
    /**
     Get all calls to a certain mock reference.

     - Parameters:
       - ref: The mock reference to check calls for.
     */
    func calls<Arguments, Result>(
        to ref: MockReference<Arguments, Result>) -> [MockCall<Arguments, Result>] {
        registeredCalls(for: ref)
    }

    /**
     Get all calls to a certain async mock reference.

     - Parameters:
       - ref: The mock reference to check calls for.
     */
    func calls<Arguments, Result>(
        to ref: AsyncMockReference<Arguments, Result>) -> [MockCall<Arguments, Result>] {
        registeredCalls(for: ref)
    }
    
    /**
     Check if a mock reference has been called.

     - Parameters:
       - ref: The mock reference to check calls for.
     */
    func hasCalled<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>) -> Bool {
        calls(to: ref).count > 0
    }

    /**
     Check if an async mock reference has been called.

     - Parameters:
       - ref: The mock reference to check calls for.
     */
    func hasCalled<Arguments, Result>(
        _ ref: AsyncMockReference<Arguments, Result>) -> Bool {
        calls(to: ref).count > 0
    }
    
    /**
     Check if a mock reference has been called.

     For this to return true the actual number of calls must
     match the provided `numberOfCalls`.

     - Parameters:
       - ref: The mock reference to check calls for.
     */
    func hasCalled<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        numberOfTimes: Int) -> Bool {
        calls(to: ref).count == numberOfTimes
    }

    /**
     Check if an async mock reference has been called.

     For this to return true the actual number of calls must
     match the provided `numberOfCalls`.

     - Parameters:
       - ref: The mock reference to check calls for.
     */
    func hasCalled<Arguments, Result>(
        _ ref: AsyncMockReference<Arguments, Result>,
        numberOfTimes: Int) -> Bool {
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
