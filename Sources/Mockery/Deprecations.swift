//
//  Deprecations.swift
//  Mockery
//
//  Created by Daniel Saidi on 2020-03-03.
//

import Foundation

public extension Mockable {
    
    @available(*, deprecated, message: "Use MockReference instead")
    func address<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> MemoryAddress {
        let (_, lo) = unsafeBitCast(function, to: (Int, Int).self)
        let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
        let pointer = UnsafePointer<Int>(bitPattern: lo + offset)!
        return pointer.pointee
    }
    
    @available(*, deprecated, renamed: "invokations(of:)")
    func executions<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> [Invokation<Arguments, Result>] {
        invokations(of: function)
    }
}

@available(*, deprecated, message: "Use MockReference instead")
public typealias MemoryAddress = Int
