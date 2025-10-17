//
//  MockableTests.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-11-25.
//  Copyright © 2020-2025 Daniel Saidi. All rights reserved.
//

import XCTest
@testable import MockingKit

class MockableTests: XCTestCase {

    fileprivate var mock: TestClass!

    override func setUp() {
        mock = TestClass()
    }

    func testCanRegisterFunctionWithReferenceIdAsResult() {
        let ref = mock.functionWithIntResultRef
        mock.registerResult(for: ref) { _, int in int * 2 }
        let obj = mock.mock.registeredResults[ref.id]
        XCTAssertNotNil(obj)
    }

    func testCanCallFunctionWithNonOptionalResultAndDifferentResultTypes() {
        let user = User(name: "a user")
        let thing = Thing(name: "a thing")

        mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
        mock.registerResult(for: mock.functionWithStringResultRef) { _ in "a string" }
        mock.registerResult(for: \.functionWithStructResultRef) { _ in user }
        mock.registerResult(for: \.functionWithClassResultRef) { _ in thing }

        let intResult = mock.functionWithIntResult(arg1: "abc", arg2: 123)
        let stringResult = mock.functionWithStringResult(arg1: "abc", arg2: 123)
        let structResult = mock.functionWithStructResult(arg1: "abc", arg2: 123)
        let classResult = mock.functionWithClassResult(arg1: "abc", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
        XCTAssertEqual(structResult, user)
        XCTAssertTrue(classResult === thing)
    }

    func testCanCallFunctionWithNonOptionalResultAndDifferentReturnValuesForDifferentArgumentValues() {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        let intResult = mock.functionWithIntResult(arg1: "abc", arg2: 123)
        let intResult2 = mock.functionWithIntResult(arg1: "abc", arg2: 456)
        let stringResult = mock.functionWithStringResult(arg1: "abc", arg2: 123)
        let stringResult2 = mock.functionWithStringResult(arg1: "def", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(intResult2, 456)
        XCTAssertEqual(stringResult, "abc")
        XCTAssertEqual(stringResult2, "def")
    }

    func testCallingFunctionWithNonOptionalResultRegistersCalls() {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = mock.functionWithIntResult(arg1: "abc", arg2: 456)
        _ = mock.functionWithIntResult(arg1: "abc", arg2: 789)
        _ = mock.functionWithStringResult(arg1: "abc", arg2: 123)
        _ = mock.functionWithStringResult(arg1: "def", arg2: 123)

        let intCalls = mock.calls(to: mock.functionWithIntResultRef)
        let strCalls = mock.calls(to: mock.functionWithStringResultRef)

        XCTAssertEqual(intCalls.count, 3)
        XCTAssertEqual(strCalls.count, 2)
        XCTAssertEqual(intCalls[0].arguments.0, "abc")
        XCTAssertEqual(intCalls[0].arguments.1, 123)
        XCTAssertEqual(intCalls[1].arguments.0, "abc")
        XCTAssertEqual(intCalls[1].arguments.1, 456)
        XCTAssertEqual(intCalls[2].arguments.0, "abc")
        XCTAssertEqual(intCalls[2].arguments.1, 789)
        XCTAssertEqual(strCalls[0].arguments.0, "abc")
        XCTAssertEqual(strCalls[0].arguments.1, 123)
        XCTAssertEqual(strCalls[1].arguments.0, "def")
        XCTAssertEqual(strCalls[1].arguments.1, 123)
    }

    func testCallingFunctionWithOptionalResultDoesNotFailWithPreconditionFailureIfNoResultIsRegistered() {
        let intResult = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let stringResult = mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let structResult = mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)
        let classResult = mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)

        XCTAssertNil(intResult)
        XCTAssertNil(stringResult)
        XCTAssertNil(structResult)
        XCTAssertNil(classResult)
    }

    func testCallingFunctionWithOptionalResultSupportsDifferentResultTypes() {
        let user = User(name: "a user")
        let thing = Thing(name: "a thing")

        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _ in 123 }
        mock.registerResult(for: mock.functionWithOptionalStringResultRef) { _ in "a string" }
        mock.registerResult(for: \.functionWithOptionalStructResultRef) { _ in user }
        mock.registerResult(for: \.functionWithOptionalClassResultRef) { _ in thing }

        let intResult = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let stringResult = mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let structResult = mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)
        let classResult = mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
        XCTAssertEqual(structResult, user)
        XCTAssertTrue(classResult === thing)
    }

    func testCallingFunctionWithOptionalResultCanRegisterDifferentReturnValuesForDifferentArgumentValues() {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        let intResult = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let int2Result = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
        let stringResult = mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let string2Result = mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(int2Result, 456)
        XCTAssertEqual(stringResult, "abc")
        XCTAssertEqual(string2Result, "def")
    }

    func testCallingFunctionWithOptionalResultRegistersCalls() {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        _ = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        _ = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
        _ = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 789)
        _ = mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        _ = mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

        let intCalls = mock.calls(to: mock.functionWithOptionalIntResultRef)
        let strCalls = mock.calls(to: \.functionWithOptionalStringResultRef)

        XCTAssertEqual(intCalls.count, 3)
        XCTAssertEqual(strCalls.count, 2)
        XCTAssertEqual(intCalls[0].arguments.0, "abc")
        XCTAssertEqual(intCalls[0].arguments.1, 123)
        XCTAssertEqual(intCalls[1].arguments.0, "abc")
        XCTAssertEqual(intCalls[1].arguments.1, 456)
        XCTAssertEqual(intCalls[2].arguments.0, "abc")
        XCTAssertEqual(intCalls[2].arguments.1, 789)
        XCTAssertEqual(strCalls[0].arguments.0, "abc")
        XCTAssertEqual(strCalls[0].arguments.1, 123)
        XCTAssertEqual(strCalls[1].arguments.0, "def")
        XCTAssertEqual(strCalls[1].arguments.1, 123)
    }

    func testCallingFunctionWithFallbackReturnsDefaultValueIfNoValueIsRegistered() {
        let intResult = mock.call(mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)
        let stringResult = mock.call(mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")

        XCTAssertEqual(intResult, 456)
        XCTAssertEqual(stringResult, "def")
    }

    func testCallingFunctionWithFallbackReturnsRegisteredValueIfAValueIsRegistered() {
        mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
        mock.registerResult(for: \.functionWithStringResultRef) { _ in "a string" }

        let intResult = mock.call(mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)
        let stringResult = mock.call(mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
    }

    func testCallingFunctionWithVoidResultDoesNotFailWithPreconditionFailureIfNoResultIsRegistered() {
        mock.functionWithVoidResult(arg1: "abc", arg2: 123)
    }

    func testCallingFunctionWithVoidResultRegistersCalls() {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        mock.functionWithVoidResult(arg1: "abc", arg2: 789)

        let calls = mock.calls(to: mock.functionWithVoidResultRef)

        XCTAssertEqual(calls.count, 3)
        XCTAssertEqual(calls[0].arguments.0, "abc")
        XCTAssertEqual(calls[0].arguments.1, 123)
        XCTAssertEqual(calls[1].arguments.0, "abc")
        XCTAssertEqual(calls[1].arguments.1, 456)
        XCTAssertEqual(calls[2].arguments.0, "abc")
        XCTAssertEqual(calls[2].arguments.1, 789)
    }


    func testInspectingCalls_RegistersAllCalls() {
        mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        mock.functionWithVoidResult(arg1: "abc", arg2: 789)

        let calls = mock.calls(to: mock.functionWithVoidResultRef)
        let callsKeypath = mock.calls(to: \.functionWithVoidResultRef)

        XCTAssertEqual(calls.count, 3)
        XCTAssertEqual(callsKeypath.count, 3)
    }

    func testInspectingCalls_canVerifyIfAtLeastOneCallHasBeenMade() {
        XCTAssertFalse(mock.hasCalled(mock.functionWithVoidResultRef))
        mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        XCTAssertTrue(mock.hasCalled(\.functionWithVoidResultRef))
        mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        XCTAssertTrue(mock.hasCalled(mock.functionWithVoidResultRef))
    }

    func testInspectingCalls_CanVerifyIfAnExactNumberOrCallsHaveBeenMade() {
        XCTAssertFalse(mock.hasCalled(mock.functionWithVoidResultRef, numberOfTimes: 2))
        mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        XCTAssertFalse(mock.hasCalled(\.functionWithVoidResultRef, numberOfTimes: 2))
        mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        XCTAssertTrue(mock.hasCalled(mock.functionWithVoidResultRef, numberOfTimes: 2))
    }

    func testResettingCalls_CanResetAllCalls() {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = mock.functionWithStringResult(arg1: "abc", arg2: 123)

        mock.resetCalls()

        XCTAssertFalse(mock.hasCalled(mock.functionWithIntResultRef))
        XCTAssertFalse(mock.hasCalled(\.functionWithStringResultRef))
    }

    func testResettingCalls_canResetAllCallsForACertainFunction() {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = mock.functionWithStringResult(arg1: "abc", arg2: 123)

        mock.resetCalls(to: mock.functionWithIntResultRef)

        XCTAssertFalse(mock.hasCalled(mock.functionWithIntResultRef))
        XCTAssertTrue(mock.hasCalled(\.functionWithStringResultRef))
    }

    func testMultiThreadedAccess_doesNotCorruptState() {
        let queueA = DispatchQueue(label: "QueueA")
        let queueB = DispatchQueue(label: "QueueB")

        let mock = TestClass()

        queueA.async {
            for index in 0..<100 {
                mock.functionWithVoidResult(arg1: "Something", arg2: index)
            }
        }

        queueB.async {
            for _ in 0..<100 {
                _ = mock.hasCalled(\.functionWithIntResultRef)
            }
        }
    }
}

private final class TestClass: AsyncTestProtocol, Mockable, @unchecked Sendable {

    let mock = Mock()

    lazy var functionWithIntResultRef = MockReference(functionWithIntResult)
    lazy var functionWithStringResultRef = MockReference(functionWithStringResult)
    lazy var functionWithStructResultRef = MockReference(functionWithStructResult)
    lazy var functionWithClassResultRef = MockReference(functionWithClassResult)
    lazy var functionWithOptionalIntResultRef = MockReference(functionWithOptionalIntResult)
    lazy var functionWithOptionalStringResultRef = MockReference(functionWithOptionalStringResult)
    lazy var functionWithOptionalStructResultRef = MockReference(functionWithOptionalStructResult)
    lazy var functionWithOptionalClassResultRef = MockReference(functionWithOptionalClassResult)
    lazy var functionWithVoidResultRef = MockReference(functionWithVoidResult)

    func functionWithIntResult(arg1: String, arg2: Int) -> Int {
        call(functionWithIntResultRef, args: (arg1, arg2))
    }

    func functionWithStringResult(arg1: String, arg2: Int) -> String {
        call(functionWithStringResultRef, args: (arg1, arg2))
    }

    func functionWithStructResult(arg1: String, arg2: Int) -> User {
        call(functionWithStructResultRef, args: (arg1, arg2))
    }

    func functionWithClassResult(arg1: String, arg2: Int) -> Thing {
        call(functionWithClassResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalIntResult(arg1: String, arg2: Int) -> Int? {
        call(functionWithOptionalIntResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalStringResult(arg1: String, arg2: Int) -> String? {
        call(functionWithOptionalStringResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalStructResult(arg1: String, arg2: Int) -> User? {
        call(functionWithOptionalStructResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalClassResult(arg1: String, arg2: Int) -> Thing? {
        call(functionWithOptionalClassResultRef, args: (arg1, arg2))
    }

    func functionWithVoidResult(arg1: String, arg2: Int) {
        call(functionWithVoidResultRef, args: (arg1, arg2))
    }
}
