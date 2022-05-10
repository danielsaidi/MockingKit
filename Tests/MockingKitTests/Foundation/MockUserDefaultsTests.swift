//
//  MockUserDefaultsTests.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2020-07-17.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation
import Quick
import Nimble
import MockingKit

class MockUserDefaultsTests: QuickSpec {

    override func spec() {
        
        var defaults: MockUserDefaults!
        
        beforeEach {
            defaults = MockUserDefaults()
        }
        
        describe("mock user defaults") {
            
            context("getter functions") {
                
                it("can mock array") {
                    defaults.registerResult(for: defaults.arrayRef) { _ in [1, 2, 3] }
                    let result = defaults.array(forKey: "abc") as? [Int]
                    expect(result).to(equal([1, 2, 3]))
                }
                
                it("can mock bool") {
                    defaults.registerResult(for: defaults.boolRef) { _ in true }
                    expect(defaults.bool(forKey: "abc")).to(equal(true))
                }
                
                it("can mock data") {
                    let data = "123".data(using: .utf8)
                    defaults.registerResult(for: defaults.dataRef) { _ in data }
                    expect(defaults.data(forKey: "abc")).to(equal(data))
                }
                
                it("can mock double") {
                    defaults.registerResult(for: defaults.doubleRef) { _ in 123 }
                    expect(defaults.double(forKey: "abc")).to(equal(123))
                }
                
                it("can mock float") {
                    defaults.registerResult(for: defaults.floatRef) { _ in 123 }
                    expect(defaults.float(forKey: "abc")).to(equal(123))
                }
                
                it("can mock integer") {
                    defaults.registerResult(for: defaults.integerRef) { _ in 123 }
                    expect(defaults.integer(forKey: "abc")).to(equal(123))
                }
                
                it("can mock object") {
                    let obj = "123"
                    defaults.registerResult(for: defaults.objectRef) { _ in obj }
                    let result = defaults.object(forKey: "abc") as? String
                    expect(result).to(equal("123"))
                }
                
                it("can mock string") {
                    defaults.registerResult(for: defaults.stringRef) { _ in "123" }
                    expect(defaults.string(forKey: "abc")).to(equal("123"))
                }
                
                it("can mock url") {
                    let url = URL(string: "http://test.com")!
                    defaults.registerResult(for: defaults.urlRef) { _ in url }
                    expect(defaults.url(forKey: "abc")).to(equal(url))
                }
            }
            
            context("setter functions") {
                
                it("can mock Bool value setter") {
                    defaults.set(true, forKey: "abc")
                    let calls = defaults.calls(to: defaults.setBoolRef).first
                    expect(calls?.arguments.0).to(equal(true))
                    expect(calls?.arguments.1).to(equal("abc"))
                }
                
                it("can mock Double value setter") {
                    defaults.set(123 as Double, forKey: "abc")
                    let calls = defaults.calls(to: defaults.setDoubleRef).first
                    expect(calls?.arguments.0).to(equal(123))
                    expect(calls?.arguments.1).to(equal("abc"))
                }
                
                it("can mock Float value setter") {
                    defaults.set(123 as Float, forKey: "abc")
                    let calls = defaults.calls(to: defaults.setFloatRef).first
                    expect(calls?.arguments.0).to(equal(123))
                    expect(calls?.arguments.1).to(equal("abc"))
                }
                
                it("can mock Int value setter") {
                    defaults.set(123, forKey: "abc")
                    let calls = defaults.calls(to: defaults.setIntegerRef).first
                    expect(calls?.arguments.0).to(equal(123))
                    expect(calls?.arguments.1).to(equal("abc"))
                }
                
                it("can mock URL value setter") {
                    let url = URL(string: "http://test.com")!
                    defaults.set(url, forKey: "abc")
                    let calls = defaults.calls(to: defaults.setUrlRef).first
                    expect(calls?.arguments.0).to(equal(url))
                    expect(calls?.arguments.1).to(equal("abc"))
                }
                
                it("can mock Any value setters") {
                    let value = "123"
                    defaults.set(value, forKey: "abc")
                    defaults.setValue(value, forKey: "def")
                    let calls = defaults.calls(to: defaults.setValueRef)
                    expect(calls.first?.arguments.0 as? String).to(equal(value))
                    expect(calls.first?.arguments.1).to(equal("abc"))
                    expect(calls.last?.arguments.0 as? String).to(equal(value))
                    expect(calls.last?.arguments.1).to(equal("def"))
                }
            }
        }
    }
}
