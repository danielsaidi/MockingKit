//
//  Mockable.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-11-25.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented when creating a mock class
 that has to inherit another class.
 
 To implement this protocol, just inherit the base class and
 this protocol, then provide a ``mock`` property:
 
 ```
 class MyMock: BaseClass, Mockable {
 
     let mock = Mock()
 }
 ```
 
 Inherit ``Mock`` instead of implementing this protocol when
 possible. It saves you a little code for each mock you make.
*/
public protocol Mockable {
    
    typealias Function = Any
    
    var mock: Mock { get }
}


// MARK: - Internal Functions

extension Mockable {

    func registerCall<Arguments, Result>(
        _ call: MockCall<Arguments, Result>,
        for ref: MockReference<Arguments, Result>
    ) {
        let calls = mock.registeredCalls[ref.id] ?? []
        mock.registeredCalls[ref.id] = calls + [call]
    }

    func registerCall<Arguments, Result>(
        _ call: MockCall<Arguments, Result>,
        for ref: AsyncMockReference<Arguments, Result>
    ) {
        let calls = mock.registeredCalls[ref.id] ?? []
        mock.registeredCalls[ref.id] = calls + [call]
    }
    
    func registeredCalls<Arguments, Result>(
        for ref: MockReference<Arguments, Result>
    ) -> [MockCall<Arguments, Result>] {
        let calls = mock.registeredCalls[ref.id]
        return (calls as? [MockCall<Arguments, Result>]) ?? []
    }

    func registeredCalls<Arguments, Result>(
        for ref: AsyncMockReference<Arguments, Result>
    ) -> [MockCall<Arguments, Result>] {
        let calls = mock.registeredCalls[ref.id]
        return (calls as? [MockCall<Arguments, Result>]) ?? []
    }

    func registeredResult<Arguments, Result>(
        for ref: MockReference<Arguments, Result>
    ) -> ((Arguments) throws -> Result)? {
        mock.registeredResults[ref.id] as? (Arguments) throws -> Result
    }

    func registeredResult<Arguments, Result>(
        for ref: AsyncMockReference<Arguments, Result>
    ) -> ((Arguments) async throws -> Result)? {
        mock.registeredResults[ref.id] as? (Arguments) async throws -> Result
    }
}
