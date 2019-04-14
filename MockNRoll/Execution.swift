/*
 
 An execution represents a function call. A function that is
 of return type `void` has `Void` as result type.
 
 */

import Foundation

public protocol AnyExecution {}

public struct Execution<Arguments, Result>: AnyExecution {
    public let arguments: Arguments
    public let result: Result
}
