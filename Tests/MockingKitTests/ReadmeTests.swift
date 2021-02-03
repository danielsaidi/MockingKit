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
        
        describe("Example code") {
            
            it("inspection works") {
                let printer = MockPrinter()
                printer.print("Hello!")
                let calls = printer.calls(to: printer.printRef)
                expect(calls[0].arguments).to(equal("Hello!"))
                expect(printer.hasCalled(printer.printRef)).to(beTrue())
                expect(printer.hasCalled(printer.printRef, times: 1)).to(beTrue())
                expect(printer.hasCalled(printer.printRef, times: 2)).to(beFalse())
            }
            
            it("registering works") {
                let converter = MockConverter()
                
                expect(converter.tryConvert("banana")).to(beNil())
                converter.registerResult(for: converter.tryConvertRef) { input in String(input.reversed()) }
                expect(converter.tryConvert("banana")).to(equal("ananab"))

                //  expect(converter.convert("banana")).to(CRASH())
                converter.registerResult(for: converter.convertRef) { input in String(input.reversed()) }
                expect(converter.convert("banana")).to(equal("ananab"))
            }
        }
    }
}


// MARK: - Readme

private protocol MyProtocol {
    func doStuff(int: Int, string: String) -> String
}

private class MyMock: Mock, MyProtocol {

    lazy var doStuffRef = MockReference(doStuff)            // References must be lazy

    func doStuff(int: Int, string: String) -> String {
        call(doStuffRef, args: (int, string))
    }
}


// MARK: - Example

private protocol Printer {
    func print(_ text: String)
}

private class MockPrinter: Mock, Printer {

    lazy var printRef = MockReference(print)                // References must be lazy

    func print(_ text: String) {
        call(printRef, args: (text))
    }
}

private protocol Converter {
    
    func convert(_ text: String) -> String
    func tryConvert(_ text: String) -> String?
}

private class MockConverter: Mock, Converter {

    lazy var convertRef = MockReference(convert)
    lazy var tryConvertRef = MockReference(tryConvert)

    func convert(_ text: String) -> String {
        call(convertRef, args: (text))
    }
    
    func tryConvert(_ text: String) -> String? {
        call(tryConvertRef, args: (text))
    }
}
