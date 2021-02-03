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
 with full `Mockable` capabilities.
 
 It's basically just a convenience layer on top of `Mockable`
 and implements `Mockable` by providing itself as a mock. It
 saves you a little code and just makes things...nicer.
 
 If your mock can't inherit this class (e.g. when creating a
 `MockedUserDefaults` that must inherit `UserDefaults`), you
 just have to implement `Mockable` instead then add a custom
 `mock` to it. The rest is identical.
 
 See `Mockable` for more information about what mocks can do.
 */
open class Mock: Mockable {
    
    public init() {}
    
    public var mock: Mock { self }
    
    var registeredCalls: [UUID: [AnyInvokation]] = [:]
    var registeredResults: [UUID: Function] = [:]
}
