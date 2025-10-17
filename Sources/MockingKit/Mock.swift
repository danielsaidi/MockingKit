//
//  Mock.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019-2025 Daniel Saidi. All rights reserved.
//

import Foundation

/// This class can be used to create mock classes without inheritance.
///
/// The class implements ``Mockable`` and returns `self` as the ``mock``,
/// to let you write less code for every mock you create.
///
/// > Note: Since Sendable conformance can cause actor isolation problem when
/// inheriting ``Mock``, prefer to implement ``Mockable`` instead. 
open class Mock: Mockable, @unchecked Sendable {
    
    public init() {}
    
    public var mock: Mock { self }
    
    var registeredCalls: [UUID: [AnyCall]] = [:]
    var registeredResults: [UUID: Function] = [:]
    let registeredCallsLock = NSLock()
}
