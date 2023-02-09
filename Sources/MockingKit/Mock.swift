//
//  Mock.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This class can be inherited when creating a mock class that
 doesn't have to inherit another class.
 
 The class implements the ``Mockable`` protocol by returning
 self as the ``mock`` property value.
 
 Inherit the class instead of implementing ``Mockable`` when
 possible. It saves you a little code for each mock you make.
 */
open class Mock: Mockable {
    
    public init() {}
    
    public var mock: Mock { self }
    
    var registeredCalls: [UUID: [AnyCall]] = [:]
    var registeredResults: [UUID: Function] = [:]
}
