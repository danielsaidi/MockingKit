/*
 
 To use this class, simply create a test class that inherits
 `Mock` and implements any protocol you need it to implement.
 
 In the class' functions (e.g. say that a function signature
 is `registerUser(name: String, age: Int)`) you just have to
 call `invoke(registerUser, arguments: ("Peter", 32))`. This
 will register the call together with the provided arguments
 and return value.
 
 For functions that return a value, just call `return invoke`
 instead of `invoke`. Before calling these functions in your
 tests, make sure to register the desired return values with
 `registerResult(for: ...) { args in ... }` function. If you
 don't, the tests will fail. Since the trailing result block
 takes the function input arguments as in arguments, you can
 return different results for different input arguments.
 
 To check that the mock received the expected function calls
 in a test, you can check the `executions(for:)` function to
 get information about how many times a functions received a
 call, with which input arguments and the returned result.
 
 Please check out the unit tests and docs for more examples.
 
 TODO: For now, this class has no error registration for all
 functions that do not return a value. This means that async
 functions can't register custom completion errors. Until it
 is implemented, you can use the single `error` property.
 
 */

import Foundation

open class Mock {
    
    
    // MARK: - Initialization
    
    public init() {}
    
    
    // MARK: - Types
    
    typealias Function = Any
    typealias FunctionAddress = Int
    
    
    // MARK: - Properties
    
    public var error: Error?
    
    var registeredExecutions: [FunctionAddress: [AnyExecution]] = [:]
    var registeredResults: [FunctionAddress: Function] = [:]
}


// MARK: - Result Registration

public extension Mock {
    
    func registerResult<Arguments, Result>(
        for function: @escaping (Arguments) throws -> Result,
        resultBlock: @escaping (Arguments) throws -> Result) {
        let address = functionAddress(of: function)
        registeredResults[address] = resultBlock
    }
}


// MARK: - Invokes

public extension Mock {
    
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments,
        file: StaticString = #file, line: UInt = #line, functionCall: StaticString = #function) rethrows -> Result {
        let address = functionAddress(of: function)
        let closure = registeredResults[address] as? (Arguments) throws -> Result
        
        let isVoid = Result.self == Void.self
        if isVoid {
            let void = unsafeBitCast((), to: Result.self)
            registeredExecutions[address] = (registeredExecutions[address] ?? []) + [Execution<Arguments, Result>(arguments: args, result: void)]
            return void
        }
        
        guard let result = try? closure?(args) else {
            preconditionFailure("⚠️ '\(functionCall)' is not stubbed.", file: file, line: line)
        }
        registeredExecutions[address] = (registeredExecutions[address] ?? []) + [Execution<Arguments, Result>(arguments: args, result: result)]
        return result
    }
    
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result?,
        args: Arguments) rethrows -> Result? {
        let address = functionAddress(of: function)
        let closure = registeredResults[address] as? (Arguments) throws -> Result?
        let result = try? closure?(args)
        registeredExecutions[address] = (registeredExecutions[address] ?? []) + [Execution<Arguments, Result?>(arguments: args, result: result)]
        return result
    }
    
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments,
        default: @autoclosure () -> Result) rethrows -> Result {
        let address = functionAddress(of: function)
        let closure = registeredResults[address] as? (Arguments) throws -> Result
        let result = (try? closure?(args)) ?? `default`()
        registeredExecutions[address] = (registeredExecutions[address] ?? []) + [Execution<Arguments, Result>(arguments: args, result: result)]
        return result
    }
}


// MARK: - Executions

public extension Mock {
    
    func executions<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> [Execution<Arguments, Result>] {
        let address = functionAddress(of: function)
        return (registeredExecutions[address] as? [Execution<Arguments, Result>]) ?? []
    }
}


// MARK: - Private Functions

private extension Mock {
    
    func functionAddress<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> Int {
        let (_, lo) = unsafeBitCast(function, to: (Int, Int).self)
        let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
        let pointer = UnsafePointer<Int>(bitPattern: lo + offset)!
        return pointer.pointee
    }
}
