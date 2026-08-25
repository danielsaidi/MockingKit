//
//  ThrowingMockReferenceTests.swift
//  MockingKit
//
//  Created by Sebastiano Zane on 25/05/2026.
//

import XCTest
@testable import MockingKit

private enum MockError: Error {
    case someError
}

class ThrowingMockReferenceTests: XCTestCase {

    private lazy var mock = TestClass()

    func testCanRegisterThrowingErrorsAsResult() {
        mock.registerResult(for: \.functionWithIntResultRef) { _, _ in throw MockError.someError }
        mock.registerResult(for: \.functionWithStringResultRef) { _, _ in throw MockError.someError }
        mock.registerResult(for: \.functionWithStructResultRef) { _, _ in throw MockError.someError }
        mock.registerResult(for: \.functionWithClassResultRef) { _, _ in throw MockError.someError }
        mock.registerResult(for: \.functionWithOptionalIntResultRef) { _, _ in throw MockError.someError }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { _, _ in throw MockError.someError }
        mock.registerResult(for: \.functionWithOptionalStructResultRef) { _, _ in throw MockError.someError }
        mock.registerResult(for: \.functionWithOptionalClassResultRef) { _, _ in throw MockError.someError }
        mock.registerResult(for: \.functionWithVoidResultRef) { _, _ in throw MockError.someError }

        XCTAssertThrowsError(try mock.functionWithIntResult(arg1: "abc", arg2: 123))
        XCTAssertThrowsError(try mock.functionWithStringResult(arg1: "abc", arg2: 123))
        XCTAssertThrowsError(try mock.functionWithStructResult(arg1: "abc", arg2: 123))
        XCTAssertThrowsError(try mock.functionWithClassResult(arg1: "abc", arg2: 123))
        XCTAssertThrowsError(try mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123))
        XCTAssertThrowsError(try mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123))
        XCTAssertThrowsError(try mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123))
        XCTAssertThrowsError(try mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123))
        XCTAssertThrowsError(try mock.functionWithVoidResult(arg1: "abc", arg2: 123))
    }

    func testCanRegisterFunctionWithReferenceIdAsResult() {
        let ref = mock.functionWithIntResultRef
        mock.registerResult(for: ref) { _, int in int * 2 }
        let obj = mock.mock.registeredResults[ref.id]
        XCTAssertNotNil(obj)
    }

    func testCanCallFunctionWithNonOptionalResultAndDifferentResultTypes() throws {
        let user = User(name: "a user")
        let thing = Thing(name: "a thing")

        mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
        mock.registerResult(for: mock.functionWithStringResultRef) { _ in "a string" }
        mock.registerResult(for: \.functionWithStructResultRef) { _ in user }
        mock.registerResult(for: \.functionWithClassResultRef) { _ in thing }

        let intResult = try mock.functionWithIntResult(arg1: "abc", arg2: 123)
        let stringResult = try mock.functionWithStringResult(arg1: "abc", arg2: 123)
        let structResult = try mock.functionWithStructResult(arg1: "abc", arg2: 123)
        let classResult = try mock.functionWithClassResult(arg1: "abc", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
        XCTAssertEqual(structResult, user)
        XCTAssertTrue(classResult === thing)
    }

    func testCanCallFunctionWithNonOptionalResultAndDifferentReturnValuesForDifferentArgumentValues() throws {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        let intResult = try mock.functionWithIntResult(arg1: "abc", arg2: 123)
        let intResult2 = try mock.functionWithIntResult(arg1: "abc", arg2: 456)
        let stringResult = try mock.functionWithStringResult(arg1: "abc", arg2: 123)
        let stringResult2 = try mock.functionWithStringResult(arg1: "def", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(intResult2, 456)
        XCTAssertEqual(stringResult, "abc")
        XCTAssertEqual(stringResult2, "def")
    }

    func testCallingFunctionWithNonOptionalResultRegistersCalls() throws {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = try mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = try mock.functionWithIntResult(arg1: "abc", arg2: 456)
        _ = try mock.functionWithIntResult(arg1: "abc", arg2: 789)
        _ = try mock.functionWithStringResult(arg1: "abc", arg2: 123)
        _ = try mock.functionWithStringResult(arg1: "def", arg2: 123)

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

    func testCallingFunctionWithOptionalResultDoesNotFailWithPreconditionFailureIfNoResultIsRegistered() throws {
        let intResult = try mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let stringResult = try mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let structResult = try mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)
        let classResult = try mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)

        XCTAssertNil(intResult)
        XCTAssertNil(stringResult)
        XCTAssertNil(structResult)
        XCTAssertNil(classResult)
    }

    func testCallingFunctionWithOptionalResultSupportsDifferentResultTypes() throws {
        let user = User(name: "a user")
        let thing = Thing(name: "a thing")

        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _ in 123 }
        mock.registerResult(for: mock.functionWithOptionalStringResultRef) { _ in "a string" }
        mock.registerResult(for: \.functionWithOptionalStructResultRef) { _ in user }
        mock.registerResult(for: \.functionWithOptionalClassResultRef) { _ in thing }

        let intResult = try mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let stringResult = try mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let structResult = try mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)
        let classResult = try mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
        XCTAssertEqual(structResult, user)
        XCTAssertTrue(classResult === thing)
    }

    func testCallingFunctionWithOptionalResultCanRegisterDifferentReturnValuesForDifferentArgumentValues() throws {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        let intResult = try mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let int2Result = try mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
        let stringResult = try mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let string2Result = try mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(int2Result, 456)
        XCTAssertEqual(stringResult, "abc")
        XCTAssertEqual(string2Result, "def")
    }

    func testCallingFunctionWithOptionalResultRegistersCalls() throws {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        _ = try mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        _ = try mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
        _ = try mock.functionWithOptionalIntResult(arg1: "abc", arg2: 789)
        _ = try mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        _ = try mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

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

    func testCallingFunctionWithFallbackReturnsDefaultValueIfNoValueIsRegistered() throws {
        let intResult = try mock.call(mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)
        let stringResult = try mock.call(mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")

        XCTAssertEqual(intResult, 456)
        XCTAssertEqual(stringResult, "def")
    }

    func testCallingFunctionWithFallbackReturnsRegisteredValueIfAValueIsRegistered() throws {
        mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
        mock.registerResult(for: \.functionWithStringResultRef) { _ in "a string" }

        let intResult = try mock.call(mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)
        let stringResult = try mock.call(mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
    }

    func testCallingFunctionWithVoidResultDoesNotFailWithPreconditionFailureIfNoResultIsRegistered() throws {
        try mock.functionWithVoidResult(arg1: "abc", arg2: 123)
    }

    func testCallingFunctionWithVoidResultRegistersCalls() throws {
        mock.registerResult(for: mock.functionWithVoidResultRef) { _, _ in }
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        try mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        try mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        try mock.functionWithVoidResult(arg1: "abc", arg2: 789)

        let calls = mock.calls(to: mock.functionWithVoidResultRef)

        XCTAssertEqual(calls.count, 3)
        XCTAssertEqual(calls[0].arguments.0, "abc")
        XCTAssertEqual(calls[0].arguments.1, 123)
        XCTAssertEqual(calls[1].arguments.0, "abc")
        XCTAssertEqual(calls[1].arguments.1, 456)
        XCTAssertEqual(calls[2].arguments.0, "abc")
        XCTAssertEqual(calls[2].arguments.1, 789)
    }

    func testInspectingCallsRegistersAllCalls() throws {
        mock.registerResult(for: mock.functionWithVoidResultRef) { _, _ in }

        try mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        try mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        try mock.functionWithVoidResult(arg1: "abc", arg2: 789)

        let calls = mock.calls(to: mock.functionWithVoidResultRef)

        XCTAssertEqual(calls.count, 3)
    }

    func testInspectingCallsCanVerifyIfAtLeastOneCallHasBeenMade() throws {
        mock.registerResult(for: mock.functionWithVoidResultRef) { _, _ in }

        XCTAssertFalse(mock.hasCalled(mock.functionWithVoidResultRef))
        try mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        XCTAssertTrue(mock.hasCalled(\.functionWithVoidResultRef))
        try mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        XCTAssertTrue(mock.hasCalled(mock.functionWithVoidResultRef))
    }

    func testInspectingCallsCanVerifyIfAnExactNumberOrCallsHaveBeenMade() throws {
        mock.registerResult(for: \.functionWithVoidResultRef) { _, _ in }

        XCTAssertFalse(mock.hasCalled(mock.functionWithVoidResultRef, numberOfTimes: 2))
        try mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        XCTAssertFalse(mock.hasCalled(\.functionWithVoidResultRef, numberOfTimes: 2))
        try mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        XCTAssertTrue(mock.hasCalled(mock.functionWithVoidResultRef, numberOfTimes: 2))
    }

    func testResettingCallsCanResetAllCalls() throws {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = try mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = try mock.functionWithStringResult(arg1: "abc", arg2: 123)

        mock.resetCalls()

        XCTAssertFalse(mock.hasCalled(mock.functionWithIntResultRef))
        XCTAssertFalse(mock.hasCalled(\.functionWithStringResultRef))
    }

    func testResettingCalls_canResetAllCallsForACertainFunction() throws {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = try mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = try mock.functionWithStringResult(arg1: "abc", arg2: 123)

        mock.resetCalls(to: mock.functionWithIntResultRef)

        XCTAssertFalse(mock.hasCalled(mock.functionWithIntResultRef))
        XCTAssertTrue(mock.hasCalled(\.functionWithStringResultRef))
    }

    func testMultiThreadedAccess_doesNotCorruptState() async throws {
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2
        let testMock = TestClass()
        testMock.registerResult(for: testMock.functionWithVoidResultRef) { _, _ in }

        Task {
            for index in 0..<100 {
                try testMock.functionWithVoidResult(arg1: "Test", arg2: index)
            }
            expectation.fulfill()
        }

        Task {
            for _ in 0..<100 {
                _ = testMock.hasCalled(\.functionWithIntResultRef)
            }
            expectation.fulfill()
        }

        await fulfillment(of: [expectation])
    }
}

private final class TestClass: Mock, @unchecked Sendable {
    lazy var functionWithIntResultRef = ThrowingMockReference(functionWithIntResult)
    lazy var functionWithStringResultRef = ThrowingMockReference(functionWithStringResult)
    lazy var functionWithStructResultRef = ThrowingMockReference(functionWithStructResult)
    lazy var functionWithClassResultRef = ThrowingMockReference(functionWithClassResult)
    lazy var functionWithOptionalIntResultRef = ThrowingMockReference(functionWithOptionalIntResult)
    lazy var functionWithOptionalStringResultRef = ThrowingMockReference(functionWithOptionalStringResult)
    lazy var functionWithOptionalStructResultRef = ThrowingMockReference(functionWithOptionalStructResult)
    lazy var functionWithOptionalClassResultRef = ThrowingMockReference(functionWithOptionalClassResult)
    lazy var functionWithVoidResultRef = ThrowingMockReference(functionWithVoidResult)

    func functionWithIntResult(arg1: String, arg2: Int) throws -> Int {
        try call(functionWithIntResultRef, args: (arg1, arg2))
    }

    func functionWithStringResult(arg1: String, arg2: Int) throws -> String {
        try call(functionWithStringResultRef, args: (arg1, arg2))
    }

    func functionWithStructResult(arg1: String, arg2: Int) throws -> User {
        try call(functionWithStructResultRef, args: (arg1, arg2))
    }

    func functionWithClassResult(arg1: String, arg2: Int) throws -> Thing {
        try call(functionWithClassResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalIntResult(arg1: String, arg2: Int) throws -> Int? {
        try call(functionWithOptionalIntResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalStringResult(arg1: String, arg2: Int) throws -> String? {
        try call(functionWithOptionalStringResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalStructResult(arg1: String, arg2: Int) throws -> User? {
        try call(functionWithOptionalStructResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalClassResult(arg1: String, arg2: Int) throws -> Thing? {
        try call(functionWithOptionalClassResultRef, args: (arg1, arg2))
    }

    func functionWithVoidResult(arg1: String, arg2: Int) throws {
        try call(functionWithVoidResultRef, args: (arg1, arg2))
    }
}
