//
//  AsyncTests.swift
//
//  Created by Tobias Boogh on 2022-05-04.
//

import Foundation

/**
 This struct is used to get a unique reference to an async function.
 */
public struct AsyncMockReference<Arguments, Result>: Identifiable {

    public init(_ function: @escaping (Arguments) async throws -> Result) {
        self.id = UUID()
        self.function = function
    }

    public let id: UUID
    public let function: (Arguments) async throws -> Result
}
