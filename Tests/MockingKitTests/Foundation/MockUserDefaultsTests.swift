//
//  MockUserDefaultsTests.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2020-07-17.
//  Copyright © 2020-2025 Daniel Saidi. All rights reserved.
//

import Foundation
import MockingKit
import XCTest

final class MockUserDefaultsTests: XCTestCase {

    var defaults: MockUserDefaults!

    override func setUp() {
        defaults = MockUserDefaults()
    }

    func testCanMockGettingArray() {
        defaults.registerResult(for: defaults.arrayRef) { _ in [1, 2, 3] }
        let result = defaults.array(forKey: "abc") as? [Int]
        XCTAssertEqual(result, [1, 2, 3])
    }

    func testCanMockGettingBool() {
        defaults.registerResult(for: defaults.boolRef) { _ in true }
        XCTAssertEqual(defaults.bool(forKey: "abc"), true)
    }

    func testCanMockGettingData() {
        let data = "123".data(using: .utf8)
        defaults.registerResult(for: defaults.dataRef) { _ in data }
        XCTAssertEqual(defaults.data(forKey: "abc"), data)
    }

    func testCanMockGettingDouble() {
        defaults.registerResult(for: defaults.doubleRef) { _ in 123 }
        XCTAssertEqual(defaults.double(forKey: "abc"), 123)
    }

    func testCanMockGettingFloat() {
        defaults.registerResult(for: defaults.floatRef) { _ in 123 }
        XCTAssertEqual(defaults.float(forKey: "abc"), 123)
    }

    func testCanMockGettingInteger() {
        defaults.registerResult(for: defaults.integerRef) { _ in 123 }
        XCTAssertEqual(defaults.integer(forKey: "abc"), 123)
    }

    func testCanMockGettingObject() {
        let obj = "123"
        defaults.registerResult(for: defaults.objectRef) { _ in obj }
        let result = defaults.object(forKey: "abc") as? String
        XCTAssertEqual(result, "123")
    }

    func testCanMockGettingString() {
        defaults.registerResult(for: defaults.stringRef) { _ in "123" }
        XCTAssertEqual(defaults.string(forKey: "abc"), "123")
    }

    func testCanMockGettingUrl() {
        let url = URL(string: "http://test.com")!
        defaults.registerResult(for: defaults.urlRef) { _ in url }
        XCTAssertEqual(defaults.url(forKey: "abc"), url)
    }

    func testCanMockSettingBool() {
        defaults.set(true, forKey: "abc")
        let calls = defaults.calls(to: defaults.setBoolRef).first
        XCTAssertEqual(calls?.arguments.0, true)
        XCTAssertEqual(calls?.arguments.1, "abc")
    }

    func testCanMockSettingDouble() {
        defaults.set(123 as Double, forKey: "abc")
        let calls = defaults.calls(to: defaults.setDoubleRef).first
        XCTAssertEqual(calls?.arguments.0, 123)
        XCTAssertEqual(calls?.arguments.1, "abc")
    }

    func testCanMockSettingFloat() {
        defaults.set(123 as Float, forKey: "abc")
        let calls = defaults.calls(to: defaults.setFloatRef).first
        XCTAssertEqual(calls?.arguments.0, 123)
        XCTAssertEqual(calls?.arguments.1, "abc")
    }

    func testCanMockSettingInt() {
        defaults.set(123, forKey: "abc")
        let calls = defaults.calls(to: defaults.setIntegerRef).first
        XCTAssertEqual(calls?.arguments.0, 123)
        XCTAssertEqual(calls?.arguments.1, "abc")
    }

    func testCanMockSettingURL() {
        let url = URL(string: "http://test.com")!
        defaults.set(url, forKey: "abc")
        let calls = defaults.calls(to: defaults.setUrlRef).first
        XCTAssertEqual(calls?.arguments.0, url)
        XCTAssertEqual(calls?.arguments.1, "abc")
    }

    func testCanMockSettingAny() {
        let value = "123"
        defaults.set(value, forKey: "abc")
        defaults.setValue(value, forKey: "def")
        let calls = defaults.calls(to: defaults.setValueRef)
        XCTAssertEqual(calls.first?.arguments.0 as? String, value)
        XCTAssertEqual(calls.first?.arguments.1, "abc")
        XCTAssertEqual(calls.last?.arguments.0 as? String, value)
        XCTAssertEqual(calls.last?.arguments.1, "def")
    }
}
