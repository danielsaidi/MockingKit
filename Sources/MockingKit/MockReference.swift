//
//  MockReference.swift
//  Mockery
//
//  Created by Daniel Saidi on 2020-07-16.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This struct is used to get a unique reference to a function.
 */
public struct MockReference<Arguments, Result>: Identifiable {
    
    public init(_ function: @escaping (Arguments) throws -> Result) {
        self.id = UUID()
        self.function = function
    }
    
    public let id: UUID
    public let function: (Arguments) throws -> Result
}
