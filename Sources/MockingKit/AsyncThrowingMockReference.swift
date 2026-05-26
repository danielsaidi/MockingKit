//
//  AsyncThrowingMockReference.swift
//  MockingKit
//
//  Created by Sebastiano Zane on 25/05/2026.
//

import Foundation

/// This type can be used to create mock function references.
public struct AsyncThrowingMockReference<Arguments, Result>: Identifiable {

    public init(_ function: @escaping (Arguments) async throws -> Result) {
        self.id = UUID()
        self.function = function
    }

    public let id: UUID
    public let function: (Arguments) async throws -> Result
}
