import Foundation

/**
 This class can be inherited to provide test classes with an
 ability to record function calls and return any result that
 you want it to.
 
 To create a mock implementation of a certain protocol, just
 inherit `Mock` and implement the protocol like this:
 
 ```swift
 class MockPrinter: Printer {
     func print(text: String) {
         invoke(print, arguments: (text))
     }
 }
 ```
 
 By calling `invoke`, the mock will record the function call
 so that you can inspect it later.
 
 You can use `calls(to:)` to check how many times a function
 was called, with which arguments and what it returned:
 
 ```swift
 let printer = MockPrinter()
 let service = MyService(printer: printer)
 service.doSomething()
 // Let's say that the service now calls print with "Hello!"
 let calls = printer.calls(to: printer.print)
 expect(calls.count).to(equal(1))
 expect(calls[0].arguments.0).to(equal("Hello!"))
 ```
 
 You use `invoke` the same way if a function returns a value.
 Make sure to register a result before you call the function,
 otherwise the test suite will crash:
 
 ```swift
 let converter = MockStringConverter()
 converter.registerResult(for: convert) { input in input.reversed() }
 return converter.convert("banana")      // Returns "ananab"
 ```
 
 Since the result block is called with the original argument
 collection, you can vary the result based on the arguments.
 
 If a class that you want to mock must inherit another class
 (e.g. a view controller) and therefore can't inherit `Mock`,
 you can add a mock to it and proxy any calls to it:
 
 ```swift
 class TestConverter: BaseStringConverter {
 
    let recorder = Mock()
 
    func convert(string: String) {
        recorder.invoke(convert, arguments: (string))
    }
 }
 ```
 
 Then inspect the `recorder` instead of the class:
 
 ```swift
 let calls = converter.recorder.calls(to: converter.convert)
 expect(calls.count).to(equal(1))
 expect(calls[0].arguments.0).to(equal("Hello!"))
 ```
 
 Please have a look at the unit tests and docs for some more
 examples and use cases.
 
 TODO: For now, this class has no error registration for all
 functions that do not return a value. This means that async
 functions can't register custom completion errors. Until it
 is implemented, you can use the single `error` property.
 */
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
            let message = """
            '\(functionCall)' has no registered result.
            You must register one with `registerResult(for:)` before calling this function.
            """
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
    
    func address<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> MemoryAddress {
        let (_, lo) = unsafeBitCast(function, to: (Int, Int).self)
        let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
        let pointer = UnsafePointer<Int>(bitPattern: lo + offset)!
        return pointer.pointee
    }
    
    func register<Arguments, Result>(_ execution: Execution<Arguments, Result>, at address: MemoryAddress) {
        registeredExecutions[address] = (registeredExecutions[address] ?? []) + [execution]
    }
    
    func registeredExecutions<Arguments, Result>(at address: MemoryAddress) -> [Execution<Arguments, Result>] {
        return (registeredExecutions[address] as? [Execution<Arguments, Result>]) ?? []
    }
}
