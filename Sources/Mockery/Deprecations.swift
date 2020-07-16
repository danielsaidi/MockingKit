//
//  Deprecations.swift
//  Mockery
//
//  Created by Daniel Saidi on 2020-03-03.
//

import Foundation

public extension Mockable {
    
    @available(*, deprecated, renamed: "invokations(of:)")
    func executions<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> [Invokation<Arguments, Result>] {
        invokations(of: function)
    }
}

@available(*, deprecated, message: "Use MockReference instead")
typealias MemoryAddress = Int
