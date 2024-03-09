//
//  MockableTests.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2020-07-17.
//  Copyright © 2020-2024 Daniel Saidi. All rights reserved.
//

import Foundation
import MockingKit
import XCTest

final class GenericTests: XCTestCase {
    
    func testCanMockGettingArray() {
        let mock = GenericMock<Int>()
        mock.doit(with: 42)
        let call = mock.calls(to: mock.doitRef)
        XCTAssertEqual(call.count, 1)
        XCTAssertEqual(call[0].arguments, 42)
    }
}

private class GenericMock<T>: Mock {
    
    lazy var doitRef = MockReference(doit)
    
    func doit(with value: T) {
        call(doitRef, args: (value))
    }
}
