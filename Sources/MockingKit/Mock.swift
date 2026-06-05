//
//  Mock.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019-2026 Daniel Saidi. All rights reserved.
//

import Foundation

/// This class can be used to create mocks that doesn't have
/// to inherit a base class.
///
/// This class implements ``Mockable`` and returns itself as
/// the ``mock``.
///
/// > Note: Since the `Sendable` conformance can cause actor
/// isolation problems, consider implementing ``Mockable``.
open class Mock: Mockable, @unchecked Sendable {
    
    public init() {}
    
    public var mock: Mock { self }
    
    var registeredCalls: [UUID: [AnyCall]] = [:]
    var registeredResults: [UUID: Function] = [:]
    let registeredCallsLock = NSLock()
}
