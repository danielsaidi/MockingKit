//
//  Mock.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This class can be inherited any classes that should be used
 as mock implementation, e.g. when unit testing.
 
 The class implements `Mockable` by using itself as a `mock`.
 Use it instead of `Mockable` whenever possible, since it is
 saving you a little bit of code for each mock.
 
 See `Mockable` for more information about what mocks can do.
 */
open class Mock: Mockable {
    
    public init() {}
    
    public var mock: Mock { self }
    
    var registeredCalls: [UUID: [AnyCall]] = [:]
    var registeredResults: [UUID: Function] = [:]
}
