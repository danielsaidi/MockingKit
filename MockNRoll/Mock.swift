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

public func escaping<Arg1>(_ arg1: Arg1) -> (Arg1)! { return (arg1) }
public func escaping<Arg1, Arg2>(_ arg1: Arg1, _ arg2: Arg2) -> (Arg1, Arg2)! { return (arg1, arg2) }
public func escaping<Arg1, Arg2, Arg3>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> (Arg1, Arg2, Arg3)! { return (arg1, arg2, arg3) }
public func escaping<Arg1, Arg2, Arg3, Arg4>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> (Arg1, Arg2, Arg3, Arg4)! { return (arg1, arg2, arg3, arg4) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> (Arg1, Arg2, Arg3, Arg4, Arg5)! { return (arg1, arg2, arg3, arg4, arg5) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)! { return (arg1, arg2, arg3, arg4, arg5, arg6) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9, _ arg10: Arg10) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9, _ arg10: Arg10, _ arg11: Arg11) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9, _ arg10: Arg10, _ arg11: Arg11, _ arg12: Arg12) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9, _ arg10: Arg10, _ arg11: Arg11, _ arg12: Arg12, _ arg13: Arg13) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9, _ arg10: Arg10, _ arg11: Arg11, _ arg12: Arg12, _ arg13: Arg13, _ arg14: Arg14) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9, _ arg10: Arg10, _ arg11: Arg11, _ arg12: Arg12, _ arg13: Arg13, _ arg14: Arg14, _ arg15: Arg15) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15, Arg16>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9, _ arg10: Arg10, _ arg11: Arg11, _ arg12: Arg12, _ arg13: Arg13, _ arg14: Arg14, _ arg15: Arg15, _ arg16: Arg16) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15, Arg16)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15, Arg16, Arg17>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9, _ arg10: Arg10, _ arg11: Arg11, _ arg12: Arg12, _ arg13: Arg13, _ arg14: Arg14, _ arg15: Arg15, _ arg16: Arg16, _ arg17: Arg17) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15, Arg16, Arg17)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15, Arg16, Arg17, Arg18>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9, _ arg10: Arg10, _ arg11: Arg11, _ arg12: Arg12, _ arg13: Arg13, _ arg14: Arg14, _ arg15: Arg15, _ arg16: Arg16, _ arg17: Arg17, _ arg18: Arg18) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15, Arg16, Arg17, Arg18)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18) }
public func escaping<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15, Arg16, Arg17, Arg18, Arg19>(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9, _ arg10: Arg10, _ arg11: Arg11, _ arg12: Arg12, _ arg13: Arg13, _ arg14: Arg14, _ arg15: Arg15, _ arg16: Arg16, _ arg17: Arg17, _ arg18: Arg18, _ arg19: Arg19) -> (Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10, Arg11, Arg12, Arg13, Arg14, Arg15, Arg16, Arg17, Arg18, Arg19)! { return (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19) }

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
        let address = self.address(of: function)
        registeredResults[address] = resultBlock
    }
}


// MARK: - Invokes

public extension Mock {
    
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments,
        file: StaticString = #file, line: UInt = #line, functionCall: StaticString = #function) rethrows -> Result {
        let address = self.address(of: function)
        
        if Result.self == Void.self {
            let void = unsafeBitCast((), to: Result.self)
            register(Execution(arguments: args, result: void), at: address)
            return void
        }
        
        let closure = registeredResults[address] as? (Arguments) throws -> Result
        guard let result = try? closure?(args) else {
            let message = "'\(functionCall)' has no registered result. You must register one with `registerResult(for:)` before calling this function."
            preconditionFailure(message, file: file, line: line)
        }
        register(Execution(arguments: args, result: result), at: address)
        return result
    }
    
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result?,
        args: Arguments) rethrows -> Result? {
        let address = self.address(of: function)
        let closure = registeredResults[address] as? (Arguments) throws -> Result?
        let result = try? closure?(args)
        register(Execution(arguments: args, result: result), at: address)
        return result
    }
    
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments,
        default: @autoclosure () -> Result) rethrows -> Result {
        let address = self.address(of: function)
        let closure = registeredResults[address] as? (Arguments) throws -> Result
        let result = (try? closure?(args)) ?? `default`()
        register(Execution(arguments: args, result: result), at: address)
        return result
    }
}


// MARK: - Escaping Invokes

public extension Mock {
    
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments!,
        file: StaticString = #file, line: UInt = #line, functionCall: StaticString = #function) rethrows -> Result {
        return try invoke(function, args: args, file: file, line: line, functionCall: functionCall)
    }
    
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result?,
        args: Arguments!) rethrows -> Result? {
        return try invoke(function, args: args)
    }
    
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments!,
        default: @autoclosure () -> Result) rethrows -> Result {
        return try invoke(function, args: args, default: `default`())
    }
}


// MARK: - Executions

public extension Mock {
    
    func executions<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> [Execution<Arguments, Result>] {
        let address = self.address(of: function)
        return registeredExecutions(at: address)
    }
}


// MARK: - Private Functions

private extension Mock {
    
    func address<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> Int {
        let (_, lo) = unsafeBitCast(function, to: (Int, Int).self)
        let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
        let pointer = UnsafePointer<Int>(bitPattern: lo + offset)!
        return pointer.pointee
    }
    
    func register<Arguments, Result>(_ execution: Execution<Arguments, Result>, at address: Int) {
        registeredExecutions[address] = (registeredExecutions[address] ?? []) + [execution]
    }
    
    func registeredExecutions<Arguments, Result>(at address: Int) -> [Execution<Arguments, Result>] {
        return (registeredExecutions[address] as? [Execution<Arguments, Result>]) ?? []
    }
}
