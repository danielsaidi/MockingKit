//
//  MockReference.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2020-07-16.
//  Copyright © 2020-2026 Daniel Saidi. All rights reserved.
//

import Foundation

/// This type can be used to create mock function references.
public struct MockReference<Arguments, Result>: Identifiable {
    
    public init(_ function: @escaping (Arguments) -> Result) {
        self.id = UUID()
        self.function = function
    }

    @available(*, deprecated, message: "Use ThrowingMockReference for throwing functions.")
    public init(_ function: @escaping (Arguments) throws -> Result) {
        self.id = UUID()
        self.function = function
    }
    
    public let id: UUID
    public let function: (Arguments) throws -> Result
}
