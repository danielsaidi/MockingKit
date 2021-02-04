//
//  TestMock.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-12-07.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import MockingKit

/**
 Inherit `Mock` if your mock doesn't have to inherit another
 class, which should be most cases.
 */
class TestMock: Mock, TestProtocol {
    
    lazy var doStuffRef = MockReference(doStuff)
    lazy var doStuffWithArgsRef = MockReference(doStuffWithArgs)
    
    func doStuff() {
        call(doStuffRef, args: ())
    }
    
    func doStuffWithArgs(name: String, age: Int) {
        call(doStuffWithArgsRef, args: (name, age))
    }
}
