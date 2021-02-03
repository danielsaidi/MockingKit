//
//  MockableTests.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2020-07-17.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
@testable import MockingKit

class GenericTests: QuickSpec {
    
    override func spec() {
        
        describe("generic mocks") {
            
            it("should work") {
                let mock = GenericMock<Int>()
                mock.doit(with: 42)
                let inv = mock.calls(to: mock.doitRef)
                expect(inv.count).to(equal(1))
                expect(inv[0].arguments).to(equal(42))
            }
        }
    }
}

private class GenericMock<T>: Mock {
    
    lazy var doitRef = MockReference(doit)
    
    func doit(with value: T) {
        invoke(doitRef, args: (value))
    }
}
