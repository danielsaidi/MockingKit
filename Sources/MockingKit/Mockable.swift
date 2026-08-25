//
//  Mockable.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-11-25.
//  Copyright © 2019-2026 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented to create custom mocks.
///
/// To implement this protocol, just implement this protocol
/// and provide a ``mock`` property:
///
/// ```
/// class MyMock: BaseClass, Mockable {
///     let mock = Mock()
/// }
/// ```
///
/// You can inherit any base class that you want to mock, to
/// create a mockable version that you can inject instead of
/// the original type. See ``MockUserDefaults`` for examples.
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

    func registerCall<Arguments, Result>(
        _ call: MockCall<Arguments, Result>,
        for ref: ThrowingMockReference<Arguments, Result>
    ) {
        mock.registeredCallsLock.withLock {
            let calls = mock.registeredCalls[ref.id] ?? []
            mock.registeredCalls[ref.id] = calls + [call]
        }
    }

    func registerCall<Arguments, Result>(
        _ call: MockCall<Arguments, Result>,
        for ref: AsyncThrowingMockReference<Arguments, Result>
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

    func registeredCalls<Arguments, Result>(
        for ref: AsyncThrowingMockReference<Arguments, Result>
    ) -> [MockCall<Arguments, Result>] {
        mock.registeredCallsLock.withLock {
            let calls = mock.registeredCalls[ref.id]
            return (calls as? [MockCall<Arguments, Result>]) ?? []
        }
    }

    func registeredCalls<Arguments, Result>(
        for ref: ThrowingMockReference<Arguments, Result>
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

    func registeredResult<Arguments, Result>(
        for ref: ThrowingMockReference<Arguments, Result>
    ) -> ((Arguments) throws -> Result)? {
        mock.registeredCallsLock.withLock {
            mock.registeredResults[ref.id] as? (Arguments) throws -> Result
        }
    }

    func registeredResult<Arguments, Result>(
        for ref: AsyncThrowingMockReference<Arguments, Result>
    ) -> ((Arguments) async throws -> Result)? {
        mock.registeredCallsLock.withLock {
            mock.registeredResults[ref.id] as? (Arguments) async throws -> Result
        }
    }
}
