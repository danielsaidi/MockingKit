//
//  MockCall.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-11-11.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This struct represents a "recorded" mock function call with
 information about the provided `arguments` and the optional
 returned `result`. A functions that doesn't return anything
 has a `Void` result.
*/
public struct MockCall<Arguments, Result>: AnyCall {
    
    public let arguments: Arguments
    public let result: Result?
}

/**
 This protocol represents any kind of mock function call. It
 is used to type erase the generic `MockCall`.
 */
public protocol AnyCall {}
