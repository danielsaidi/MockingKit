//
//  AsyncTests.swift
//  MockingKit
//
//  Created by Tobias Boogh on 2022-05-04.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This struct can be used to create async function references.

 Mock function references get unique IDs, which means that a
 mock reference instance can be uniquely identifier.
 */
public struct AsyncMockReference<Arguments, Result>: Identifiable {

    public init(_ function: @escaping (Arguments) async throws -> Result) {
        self.id = UUID()
        self.function = function
    }

    public let id: UUID
    public let function: (Arguments) async throws -> Result
}
