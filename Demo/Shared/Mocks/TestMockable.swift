//
//  TestMockable.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-12-07.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 Implement the `Mockable` protocol if your mock must inherit
 another class, which e.g. is needed when you want to create
 mock implementations of for instance a `NotificationCenter`.
 */
class TestMockable: NotificationCenter, Mockable, TestProtocol {
    
    let mock = Mock()
    
    lazy var doStuffRef = MockReference(doStuff)
    lazy var doStuffWithArgsRef = MockReference(doStuffWithArgs)
    
    func doStuff() {
        call(doStuffRef, args: ())
    }
    
    func doStuffWithArgs(name: String, age: Int) {
        call(doStuffWithArgsRef, args: (name, age))
    }
}
