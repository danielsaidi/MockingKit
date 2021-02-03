//
//  ReadmeTests.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2020-07-17.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
@testable import MockingKit

class ReadmeTests: QuickSpec {

    override func spec() {
        
        describe("README code") {
            
            it("works") {
                let mock = MyMock()
                mock.registerResult(for: mock.doStuffRef) { args in String(args.1.reversed()) }
                let result = mock.doStuff(int: 42, string: "string")
                expect(result).to(equal("gnirts"))
                let calls = mock.calls(to: mock.doStuffRef)
                expect(calls.count).to(equal(1))
                expect(calls[0].arguments.0).to(equal(42))
                expect(calls[0].arguments.1).to(equal("string"))
                expect(calls[0].result).to(equal("gnirts"))
                expect(mock.hasCalled(mock.doStuffRef)).to(beTrue())
                expect(mock.hasCalled(mock.doStuffRef, times: 1)).to(beTrue())
                expect(mock.hasCalled(mock.doStuffRef, times: 2)).to(beFalse())
            }
        }
    }
}

private protocol MyProtocol {
    func doStuff(int: Int, string: String) -> String
}

private class MyMock: Mock, MyProtocol {

    lazy var doStuffRef = MockReference(doStuff)  // This has to be lazy

    func doStuff(int: Int, string: String) -> String {
        calls(doStuffRef, args: (int, string))
    }
}
