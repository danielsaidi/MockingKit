import Foundation

/**
 An invokation represents a function call with arguments and
 result information.
 
 A function that doesn't return anything has a `Void` result.
 
 Original implementation: https://github.com/devxoul/Stubber
*/
public struct Invokation<Arguments, Result>: AnyInvokation {
    
    public let arguments: Arguments
    public let result: Result
}
