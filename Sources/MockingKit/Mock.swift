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
 
 The class implements `Mockable` by using itself as ``mock``.
 Use it instead of implementing `Mockable` whenever possible,
 since it saves you a little code for each mock.
 
 See ``Mockable`` for information about what a mockable type
 can do.
 */
open class Mock: Mockable {
    
    public init() {}
    
    public var mock: Mock { self }
    
    var registeredCalls: [UUID: [AnyCall]] = [:]
    var registeredResults: [UUID: Function] = [:]
}
