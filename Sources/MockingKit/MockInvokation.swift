//
//  Invokation.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-11-11.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 An invokation represents a function call with arguments and
 result information. A function that doesn't return anything
 has a `Void` result.
*/
public struct MockInvokation<Arguments, Result>: AnyInvokation {
    
    public let arguments: Arguments
    public let result: Result?
}

/**
 This protocol represents any kind of invocation and is used
 to internally type erase the generic `Invokation` struct.
 */
public protocol AnyInvokation {}
