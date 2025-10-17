//
//  Mockable.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-11-25.
//  Copyright © 2019-2025 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented to create custom mock types.
///
/// To implement this protocol, just implement the protocol or inherit the class that
/// you want to mock, then provide a ``mock`` property:
///
/// ```
/// class MyMock: BaseClass, Mockable {
///     let mock = Mock()
/// }
/// ```
///
/// > Note: Since Sendable conformance can cause actor isolation problem when
/// inheriting ``Mock``, prefer to implement ``Mockable`` instead.
public protocol Mockable: Sendable {
    
    typealias Function = Any
    
    var mock: Mock { get }
}


// MARK: - Internal Functions

extension Mockable {

    func registerCall<Arguments, Result>(
        _ call: MockCall<Arguments, Result>,
        for ref: MockReference<Arguments, Result>
    ) {
        mock.registeredCallsLock.withLock {
            let calls = mock.registeredCalls[ref.id] ?? []
            mock.registeredCalls[ref.id] = calls + [call]
        }
    }

    func registerCall<Arguments, Result>(
        _ call: MockCall<Arguments, Result>,
        for ref: AsyncMockReference<Arguments, Result>
    ) {
        mock.registeredCallsLock.withLock {
            let calls = mock.registeredCalls[ref.id] ?? []
            mock.registeredCalls[ref.id] = calls + [call]
        }
    }
    
    func registeredCalls<Arguments, Result>(
        for ref: MockReference<Arguments, Result>
    ) -> [MockCall<Arguments, Result>] {
        mock.registeredCallsLock.withLock {
            let calls = mock.registeredCalls[ref.id]
            return (calls as? [MockCall<Arguments, Result>]) ?? []
        }
    }

    func registeredCalls<Arguments, Result>(
        for ref: AsyncMockReference<Arguments, Result>
    ) -> [MockCall<Arguments, Result>] {
        mock.registeredCallsLock.withLock {
            let calls = mock.registeredCalls[ref.id]
            return (calls as? [MockCall<Arguments, Result>]) ?? []
        }
    }

    func registeredResult<Arguments, Result>(
        for ref: MockReference<Arguments, Result>
    ) -> ((Arguments) throws -> Result)? {
        mock.registeredCallsLock.withLock {
            let result = mock.registeredResults[ref.id] as? (Arguments) throws -> Result
            return result
        }
    }

    func registeredResult<Arguments, Result>(
        for ref: AsyncMockReference<Arguments, Result>
    ) -> ((Arguments) async throws -> Result)? {
        mock.registeredCallsLock.withLock {
            let result = mock.registeredResults[ref.id] as? (Arguments) async throws -> Result
            return result
        }
    }
}
