import Foundation

public extension Mockable {
    
    @available(*, deprecated, renamed: "call()")
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        args: Arguments,
        file: StaticString = #file,
        line: UInt = #line,
        functionCall: StaticString = #function) -> Result {
        call(ref, args: args, file: file, line: line, functionCall: functionCall)
    }
    
    @available(*, deprecated, renamed: "call(args:fallback:)")
    func invoke<Arguments, Result>(
        _ ref: MockReference<Arguments, Result>,
        args: Arguments,
        fallback: @autoclosure () -> Result) -> Result {
        call(ref, args: args, fallback: fallback())
    }
    
    @available(*, deprecated, renamed: "call(args:fallback:)")
    func invoke<Arguments, Result>(_ ref: MockReference<Arguments, Result>, args: Arguments!, fallback: @autoclosure () -> Result) throws -> Result {
        try call(ref, args: args, fallback: fallback())
    }
    
    @available(*, deprecated, renamed: "call(args:)")
    func invoke<Arguments, Result>(_ ref: MockReference<Arguments, Result?>, args: Arguments) -> Result? {
        call(ref, args: args)
    }
    
    @available(*, deprecated, renamed: "call(args:)")
    func invoke<Arguments, Result>(_ ref: MockReference<Arguments, Result?>, args: Arguments!) throws -> Result? {
        try call(ref, args: args)
    }
    
    @available(*, deprecated, renamed: "resetCalls()")
    func resetInvokations() {
        resetCalls()
    }
    
    @available(*, deprecated, renamed: "resetCalls(to:)")
    func resetInvokations<Arguments, Result>(for ref: MockReference<Arguments, Result>) {
        resetCalls(to: ref)
    }
}

public extension Mockable {
    
    @available(*, deprecated, renamed: "calls(to:)")
    func invokations<Arguments, Result>(of ref: MockReference<Arguments, Result>) -> [MockInvokation<Arguments, Result>] {
        calls(to: ref)
    }
    
    @available(*, deprecated, renamed: "hasCalled()")
    func hasInvoked<Arguments, Result>(_ ref: MockReference<Arguments, Result>) -> Bool {
        hasCalled(ref)
    }
    
    @available(*, deprecated, renamed: "hasCalled(numberOfTimes:)")
    func hasInvoked<Arguments, Result>(_ ref: MockReference<Arguments, Result>, numberOfTimes: Int) -> Bool {
        hasCalled(ref, numberOfTimes: numberOfTimes)
    }
}
