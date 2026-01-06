//
//  TestMockable.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-12-07.
//  Copyright © 2020-2026 Daniel Saidi. All rights reserved.
//

import Foundation
import MockingKit

class TestMockable: NotificationCenter, Mockable, TestProtocol, @unchecked Sendable {
    
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
