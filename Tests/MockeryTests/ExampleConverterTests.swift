//
//  ExampleConverterTests.swift
//  MockeryTests
//
//  Created by Daniel Saidi on 2020-07-17.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
@testable import Mockery

class ExampleConverterTests: QuickSpec {

    override func spec() {
        
        describe("Example converter") {
            
            it("works") {
                let mock = MockConverter()
                //let result = converter.convert("banana") // => Crash!
                mock.registerResult(for: mock.convertRef) { input in String(input.reversed()) }
                expect(mock.convert("banana")).to(equal("ananab"))
            }
        }
    }
}

private protocol Converter {
    func convert(_ text: String) -> String
}

private class MockConverter: Mock, Converter {

    lazy var convertRef = MockReference(convert)

    func convert(_ text: String) -> String {
        invoke(convertRef, args: (text))
    }
}
