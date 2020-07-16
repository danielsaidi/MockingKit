//
//  Mock.swift
//  Mockery
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This class can be inherited by mock classes that don't have
 to inherit another base class.
 
 Classes that must inherit another base class (e.g. a mocked
 system class) should implement `Mockable` and create a mock
 instance instead. This class implements `Mockable` by using
 itself as the mock.
 
 See `Mockable` for more information about what mocks can do.
 */
open class Mock: Mockable {
    
    public init() {}
    
    public var mock: Mock { self }
    
    var registeredInvokations: [UUID: [AnyInvokation]] = [:]
    var registeredResults: [UUID: Function] = [:]
}
