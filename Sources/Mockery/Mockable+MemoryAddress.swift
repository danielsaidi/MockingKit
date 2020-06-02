//
//  Mockable.swift
//  Mockery
//
//  Created by Daniel Saidi on 2020-02-10.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation

extension Mockable {
    
    /**
     Resolve the memory address of a function reference.
     */
    func address<Arguments, Result>(of function: @escaping (Arguments) throws -> Result) -> MemoryAddress {
        let (_, lo) = unsafeBitCast(function, to: (Int, Int).self)
        let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
        let pointer = UnsafePointer<Int>(bitPattern: lo + offset)!
        return pointer.pointee
    }
}
