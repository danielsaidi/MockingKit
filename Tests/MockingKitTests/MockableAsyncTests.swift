//
//  MockableAsyncTests.swift
//  MockingKit
//
//  Created by Tobias Boogh on 2022-05-04.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import XCTest
@testable import MockingKit

class MockableAsyncTests: XCTestCase {

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

    func testCanCallFunctionWithNonOptionalResultAndDifferentResultTypes() async {
        let user = User(name: "a user")
        let thing = Thing(name: "a thing")

        mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
        mock.registerResult(for: mock.functionWithStringResultRef) { _ in "a string" }
        mock.registerResult(for: \.functionWithStructResultRef) { _ in user }
        mock.registerResult(for: \.functionWithClassResultRef) { _ in thing }

        let intResult = await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        let stringResult = await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        let structResult = await mock.functionWithStructResult(arg1: "abc", arg2: 123)
        let classResult = await mock.functionWithClassResult(arg1: "abc", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
        XCTAssertEqual(structResult, user)
        XCTAssertTrue(classResult === thing)
    }

    func testCanCallFunctionWithNonOptionalResultAndDifferentReturnValuesForDifferentArgumentValues() async {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        let intResult = await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        let intResult2 = await mock.functionWithIntResult(arg1: "abc", arg2: 456)
        let stringResult = await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        let stringResult2 = await mock.functionWithStringResult(arg1: "def", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(intResult2, 456)
        XCTAssertEqual(stringResult, "abc")
        XCTAssertEqual(stringResult2, "def")
    }

    func testCallingFunctionWithNonOptionalResultRegistersCalls() async {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithIntResult(arg1: "abc", arg2: 456)
        _ = await mock.functionWithIntResult(arg1: "abc", arg2: 789)
        _ = await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithStringResult(arg1: "def", arg2: 123)

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

    func testCallingFunctionWithOptionalResultDoesNotFailWithPreconditionFailureIfNoResultIsRegistered() async {
        let intResult = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let stringResult = await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let structResult = await mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)
        let classResult = await mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)

        XCTAssertNil(intResult)
        XCTAssertNil(stringResult)
        XCTAssertNil(structResult)
        XCTAssertNil(classResult)
    }

    func testCallingFunctionWithOptionalResultSupportsDifferentResultTypes() async {
        let user = User(name: "a user")
        let thing = Thing(name: "a thing")

        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _ in 123 }
        mock.registerResult(for: mock.functionWithOptionalStringResultRef) { _ in "a string" }
        mock.registerResult(for: \.functionWithOptionalStructResultRef) { _ in user }
        mock.registerResult(for: \.functionWithOptionalClassResultRef) { _ in thing }

        let intResult = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let stringResult = await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let structResult = await mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)
        let classResult = await mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
        XCTAssertEqual(structResult, user)
        XCTAssertTrue(classResult === thing)
    }

    func testCallingFunctionWithOptionalResultCanRegisterDifferentReturnValuesForDifferentArgumentValues() async {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        let intResult = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let int2Result = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
        let stringResult = await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let string2Result = await mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(int2Result, 456)
        XCTAssertEqual(stringResult, "abc")
        XCTAssertEqual(string2Result, "def")
    }
    func testCallingFunctionWithOptionalResultRegistersCalls() async {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        _ = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
        _ = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 789)
        _ = await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

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

    func testCallingFunctionWithFallbackReturnsDefaultValueIfNoValueIsRegistered() async {
        let intResult = await mock.call(mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)
        let stringResult = await mock.call(mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")

        XCTAssertEqual(intResult, 456)
        XCTAssertEqual(stringResult, "def")
    }

    func testCallingFunctionWithFallbackReturnsRegisteredValueIfAValueIsRegistered() async {
        mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
        mock.registerResult(for: \.functionWithStringResultRef) { _ in "a string" }

        let intResult = await mock.call(mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)
        let stringResult = await mock.call(mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
    }

    func testCallingFunctionWithVoidResultDoesNotFailWithPreconditionFailureIfNoResultIsRegistered() async {
        await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
    }

    func testCallingFunctionWithVoidResultRegistersCalls() async {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        await mock.functionWithVoidResult(arg1: "abc", arg2: 789)

        let calls = mock.calls(to: mock.functionWithVoidResultRef)

        XCTAssertEqual(calls.count, 3)
        XCTAssertEqual(calls[0].arguments.0, "abc")
        XCTAssertEqual(calls[0].arguments.1, 123)
        XCTAssertEqual(calls[1].arguments.0, "abc")
        XCTAssertEqual(calls[1].arguments.1, 456)
        XCTAssertEqual(calls[2].arguments.0, "abc")
        XCTAssertEqual(calls[2].arguments.1, 789)
    }

    func testInspectingCallsRegistersAllCalls() async {
        await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        await mock.functionWithVoidResult(arg1: "abc", arg2: 789)

        let calls = mock.calls(to: mock.functionWithVoidResultRef)

        XCTAssertEqual(calls.count, 3)
    }

    func testInspectingCallsCanVerifyIfAtLeastOneCallHasBeenMade() async {
        XCTAssertFalse(mock.hasCalled(mock.functionWithVoidResultRef))
        await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        XCTAssertTrue(mock.hasCalled(\.functionWithVoidResultRef))
        await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        XCTAssertTrue(mock.hasCalled(mock.functionWithVoidResultRef))
    }

    func testInspectingCallsCanVerifyIfAnExactNumberOrCallsHaveBeenMade() async {
        XCTAssertFalse(mock.hasCalled(mock.functionWithVoidResultRef, numberOfTimes: 2))
        await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        XCTAssertFalse(mock.hasCalled(\.functionWithVoidResultRef, numberOfTimes: 2))
        await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        XCTAssertTrue(mock.hasCalled(mock.functionWithVoidResultRef, numberOfTimes: 2))
    }

    func testResettingCallsCanResetAllCalls() async {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithStringResult(arg1: "abc", arg2: 123)

        mock.resetCalls()

        XCTAssertFalse(mock.hasCalled(mock.functionWithIntResultRef))
        XCTAssertFalse(mock.hasCalled(\.functionWithStringResultRef))
    }

    func testResettingCalls_canResetAllCallsForACertainFunction() async {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithStringResult(arg1: "abc", arg2: 123)

        mock.resetCalls(to: mock.functionWithIntResultRef)

        XCTAssertFalse(mock.hasCalled(mock.functionWithIntResultRef))
        XCTAssertTrue(mock.hasCalled(\.functionWithStringResultRef))
    }
}

private class TestClass: AsyncTestProtocol, Mockable {

    var mock = Mock()

    lazy var functionWithIntResultRef = AsyncMockReference(functionWithIntResult)
    lazy var functionWithStringResultRef = AsyncMockReference(functionWithStringResult)
    lazy var functionWithStructResultRef = AsyncMockReference(functionWithStructResult)
    lazy var functionWithClassResultRef = AsyncMockReference(functionWithClassResult)
    lazy var functionWithOptionalIntResultRef = AsyncMockReference(functionWithOptionalIntResult)
    lazy var functionWithOptionalStringResultRef = AsyncMockReference(functionWithOptionalStringResult)
    lazy var functionWithOptionalStructResultRef = AsyncMockReference(functionWithOptionalStructResult)
    lazy var functionWithOptionalClassResultRef = AsyncMockReference(functionWithOptionalClassResult)
    lazy var functionWithVoidResultRef = AsyncMockReference(functionWithVoidResult)

    func functionWithIntResult(arg1: String, arg2: Int) async -> Int {
        await call(functionWithIntResultRef, args: (arg1, arg2))
    }

    func functionWithStringResult(arg1: String, arg2: Int) async -> String {
        await call(functionWithStringResultRef, args: (arg1, arg2))
    }

    func functionWithStructResult(arg1: String, arg2: Int) async -> User {
        await call(functionWithStructResultRef, args: (arg1, arg2))
    }

    func functionWithClassResult(arg1: String, arg2: Int) async -> Thing {
        await call(functionWithClassResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalIntResult(arg1: String, arg2: Int) async -> Int? {
        await call(functionWithOptionalIntResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalStringResult(arg1: String, arg2: Int) async -> String? {
        await call(functionWithOptionalStringResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalStructResult(arg1: String, arg2: Int) async -> User? {
        await call(functionWithOptionalStructResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalClassResult(arg1: String, arg2: Int) async -> Thing? {
        await call(functionWithOptionalClassResultRef, args: (arg1, arg2))
    }

    func functionWithVoidResult(arg1: String, arg2: Int) async {
        await call(functionWithVoidResultRef, args: (arg1, arg2))
    }
}
