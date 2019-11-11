import Foundation

/**
 This protocol represents any kind of execution.
 
 Original implementation: https://github.com/devxoul/Stubber
 */
public protocol AnyExecution {}

/**
 An execution represents a function call. A function that is
 of return type `void` has `Void` as result type.
 
 Original implementation: https://github.com/devxoul/Stubber
*/
public struct Execution<Arguments, Result>: AnyExecution {
    
    public let arguments: Arguments
    public let result: Result
}
