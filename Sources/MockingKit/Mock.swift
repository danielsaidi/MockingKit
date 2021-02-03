//
//  Mock.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This class can be inherited by your mocks and provides them
 with full mocking capabilities.
 
 The class implements `Mockable` by using itself as mock. It
 saves you some code and makes things...nicer. If a mock has
 to inherit another class, just implement `Mockable` instead
 and add a `mock` property to it. The rest is identical.
 
 See `Mockable` for more information about what mocks can do.
 */
open class Mock: Mockable {
    
    public init() {}
    
    public var mock: Mock { self }
    
    var registeredCalls: [UUID: [AnyCall]] = [:]
    var registeredResults: [UUID: Function] = [:]
}
