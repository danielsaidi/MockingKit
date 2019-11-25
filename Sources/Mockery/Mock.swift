//
//  Mock.swift
//  Mockery
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 Inheriting `Mock` makes it easily to create mocked protocol
 implementations, provided that the test class does not have
 to inherit another class. Classes that must inherit another
 class (e.g. notification center) should implement `Mockable`
 instead and fulfull that protocol.
 
 See `Mockable` for more information about what mocks can do.
 */
open class Mock: Mockable {
    
    public init() {}
    
    public var mock: Mock { self }
    
    var registeredInvokations: [FunctionAddress: [AnyInvokation]] = [:]
    var registeredResults: [FunctionAddress: Function] = [:]
}
