//
//  MockReference.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2020-07-16.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This struct can be used to create a mock function reference.

 Mock function references get unique IDs, which means that a
 mock reference instance can be uniquely identifier.
 */
public struct MockReference<Arguments, Result>: Identifiable {
    
    public init(_ function: @escaping (Arguments) throws -> Result) {
        self.id = UUID()
        self.function = function
    }
    
    public let id: UUID
    public let function: (Arguments) throws -> Result
}
