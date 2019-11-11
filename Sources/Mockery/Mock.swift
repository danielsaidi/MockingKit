import Foundation

/**
 This class can be inherited to provide test classes with an
 ability to record function calls and return any result that
 you want it to.
 
 To create a mock implementation of a certain protocol, just
 inherit `Mock` and implement the protocol like this:
 
 ```swift
 class MockPrinter: Printer {
     func print(_ text: String) {
         invoke(print, arguments: (text))
     }
 }
 ```
 
 By calling `invoke`, the mock will record the function call
 so that you can inspect it later:
 
 ```swift
 let printer = MockPrinter()
 printer.print("Hello!")
 let invokations = printer.invokations(of: printer.print)   // => 1 item
 invokations[0].arguments.0                                 // => "Hello!"
 printer.didInvoke(printer.print)                           // => true
 printer.didInvoke(printer.print, numberOfTimes: 1)         // => true
 printer.didInvoke(printer.print, numberOfTimes: 2)         // => false
 ```
 
 You call `invoke` in the same way for functions that return
 a result. For returning functions, `invoke` will return any
 pre-registered return value.
 
 ```swift
 class MockConverter: Converter {
     func convert(_ text: String) -> String {
         invoke(convert, arguments: (text))
     }
 }
 ```
 
 Make sure to register a result before calling the returning
 functions, otherwise they will crash when being called:
 
 ```swift
 let converter = MockStringConverter()
 converter.registerResult(for: convert) { input in input.reversed() }
 return converter.convert("banana")      // Returns "ananab"
 ```
 
 Since the result block is called with the original argument
 collection, you can vary the result based on the arguments.
 
 If a class that you want to mock must inherit another class
 (e.g. a view controller) and therefore can't inherit `Mock`,
 you can create a mock and proxy any invokations to it:
 
 ```swift
 class TestConverter: BaseStringConverter {
 
    let recorder = Mock()
 
    func convert(string: String) {
        recorder.invoke(convert, arguments: (string))
    }
 }
 ```
 
 You can then inspect the `recorder` instead of the class:
 
 ```swift
 let converter = TestConverter()
 converter.convert("Good evening!")
 converter.recorder.invokations(of: converter.convert)
 ```
 
 Have a look at the unit tests and readmes for more examples
 and use cases.
 
 TODO: For now, this class has no error registration for all
 functions that do not return a value. This means that async
 functions can't register custom completion errors. Until it
 is implemented, you can use the single `error` property.
 
 TODO: The function address approach does not work when unit
 test are run on a 32 bit device or simulator.
 
 TODO: The function address approach does not work when your
 mock class is defined in another target than the test suite.
 */
open class Mock {
    
    public init() {}
    
    typealias Function = Any
    typealias FunctionAddress = Int
    
    public var error: Error?
    
    var registeredInvokations: [FunctionAddress: [AnyInvokation]] = [:]
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
            register(Invokation(arguments: args, result: void), at: address)
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
        register(Invokation(arguments: args, result: result), at: address)
        return result
    }
    
    /**
     Invoke a function that has a non-optional return value.
     
     This function will return a registered return value or
     the provided fallback if no value has been registered.
    */
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments,
        fallback: @autoclosure () -> Result) rethrows -> Result {
        let address = self.address(of: function)
        let closure = registeredResults[address] as? (Arguments) throws -> Result
        let result = (try? closure?(args)) ?? fallback()
        register(Invokation(arguments: args, result: result), at: address)
        return result
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
        let closure = registeredResults[address] as? (Arguments) throws -> Result?
        let result = try? closure?(args)
        register(Invokation(arguments: args, result: result), at: address)
        return result
    }}


// MARK: - Escaping Invokes

public extension Mock {
    
    /**
     Invoke a function that has a non-optional return value
     and one or many escaping parameters.
     
     This will return a registered return value, if any, or
     crash if no return value has been registered.
    */
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result,
        args: Arguments!,
        file: StaticString = #file, line: UInt = #line, functionCall: StaticString = #function) rethrows -> Result {
        try invoke(function, args: args, file: file, line: line, functionCall: functionCall)
    }
    
    /**
     Invoke a function that has a non-optional return value
     and one or many escaping parameters.
     
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
     Invoke a function that has an optional return value and
     one or many escaping parameters.
     
     This will return a registered return value, if any, or
     `nil` if no return value has been registered.
    */
    func invoke<Arguments, Result>(
        _ function: @escaping (Arguments) throws -> Result?,
        args: Arguments!) rethrows -> Result? {
        try invoke(function, args: args)
    }
}


// MARK: - Inspection

public extension Mock {
    
    func invokations<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> [Invokation<Arguments, Result>] {
        registeredCalls(at: address(of: function))
    }
    
    func didInvoke<Arguments, Result>(_ function: @escaping (Arguments) throws -> Result) -> Bool {
        invokations(of: function).count > 0
    }
    
    func didInvoke<Arguments, Result>(_ function: @escaping (Arguments) throws -> Result, numberOfTimes: Int) -> Bool {
        invokations(of: function).count == numberOfTimes
    }
}


// MARK: - Private Functions

private extension Mock {
    
    /**
     Resolve the memory address of a function reference.
     */
    func address<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> MemoryAddress {
        let (_, lo) = unsafeBitCast(function, to: (Int, Int).self)
        let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
        let pointer = UnsafePointer<Int>(bitPattern: lo + offset)!
        return pointer.pointee
    }
    
    /**
     Register a function execution at a memory address.
     */
    func register<Arguments, Result>(_ execution: Invokation<Arguments, Result>, at address: MemoryAddress) {
        registeredInvokations[address] = (registeredInvokations[address] ?? []) + [execution]
    }
    
    /**
     Get all registered function executions for a certain memory address.
    */
    func registeredCalls<Arguments, Result>(at address: MemoryAddress) -> [Invokation<Arguments, Result>] {
        return (registeredInvokations[address] as? [Invokation<Arguments, Result>]) ?? []
    }
}


// MARK: - Executions

public extension Mock {
    
    @available(*, deprecated, renamed: "calls(to:)")
    func executions<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> [Invokation<Arguments, Result>] {
        invokations(of: function)
    }
}
