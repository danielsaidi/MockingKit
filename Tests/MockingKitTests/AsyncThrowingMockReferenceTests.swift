//
//  AsyncThrowingMockReferenceTests.swift
//  MockingKit
//
//  Created by Sebastiano Zane on 25/05/2026.
//

import XCTest
@testable import MockingKit

private enum MockError: Error {
    case someError
}

class AsyncThrowingMockReferenceTests: XCTestCase {

    private lazy var mock = TestClass()

    func testCanRegisterThrowingErrorsAsResult() async {
        mock.registerResult(for: \.functionWithIntResultRef) {_,_ in throw MockError.someError }
        mock.registerResult(for: \.functionWithStringResultRef) {_,_ in throw MockError.someError }
        mock.registerResult(for: \.functionWithStructResultRef) {_,_ in throw MockError.someError }
        mock.registerResult(for: \.functionWithClassResultRef) {_,_ in throw MockError.someError }
        mock.registerResult(for: \.functionWithOptionalIntResultRef) {_,_ in throw MockError.someError }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) {_,_ in throw MockError.someError }
        mock.registerResult(for: \.functionWithOptionalStructResultRef) {_,_ in throw MockError.someError }
        mock.registerResult(for: \.functionWithOptionalClassResultRef) {_,_ in throw MockError.someError }
        mock.registerResult(for: \.functionWithVoidResultRef) {_,_ in throw MockError.someError }

        await assertThrowsAsyncError { try await mock.functionWithIntResult(arg1: "abc", arg2: 123) }
        await assertThrowsAsyncError { try await mock.functionWithStringResult(arg1: "abc", arg2: 123) }
        await assertThrowsAsyncError { try await mock.functionWithStructResult(arg1: "abc", arg2: 123) }
        await assertThrowsAsyncError { try await mock.functionWithClassResult(arg1: "abc", arg2: 123) }
        await assertThrowsAsyncError { try await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123) }
        await assertThrowsAsyncError { try await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123) }
        await assertThrowsAsyncError { try await mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123) }
        await assertThrowsAsyncError { try await mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123) }
        await assertThrowsAsyncError { try await mock.functionWithVoidResult(arg1: "abc", arg2: 123) }
    }

    func testCanRegisterFunctionWithReferenceIdAsResult() {
        let ref = mock.functionWithIntResultRef
        mock.registerResult(for: ref) { _, int in int * 2 }
        let obj = mock.mock.registeredResults[ref.id]
        XCTAssertNotNil(obj)
    }

    func testCanCallFunctionWithNonOptionalResultAndDifferentResultTypes() async throws {
        let user = User(name: "a user")
        let thing = Thing(name: "a thing")

        mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
        mock.registerResult(for: mock.functionWithStringResultRef) { _ in "a string" }
        mock.registerResult(for: \.functionWithStructResultRef) { _ in user }
        mock.registerResult(for: \.functionWithClassResultRef) { _ in thing }

        let intResult = try await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        let stringResult = try await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        let structResult = try await mock.functionWithStructResult(arg1: "abc", arg2: 123)
        let classResult = try await mock.functionWithClassResult(arg1: "abc", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
        XCTAssertEqual(structResult, user)
        XCTAssertTrue(classResult === thing)
    }

    func testCanCallFunctionWithNonOptionalResultAndDifferentReturnValuesForDifferentArgumentValues() async throws {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        let intResult = try await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        let intResult2 = try await mock.functionWithIntResult(arg1: "abc", arg2: 456)
        let stringResult = try await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        let stringResult2 = try await mock.functionWithStringResult(arg1: "def", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(intResult2, 456)
        XCTAssertEqual(stringResult, "abc")
        XCTAssertEqual(stringResult2, "def")
    }

    func testCallingFunctionWithNonOptionalResultRegistersCalls() async throws {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = try await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = try await mock.functionWithIntResult(arg1: "abc", arg2: 456)
        _ = try await mock.functionWithIntResult(arg1: "abc", arg2: 789)
        _ = try await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        _ = try await mock.functionWithStringResult(arg1: "def", arg2: 123)

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

    func testCallingFunctionWithOptionalResultDoesNotFailWithPreconditionFailureIfNoResultIsRegistered() async throws {
        let intResult = try await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let stringResult = try await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let structResult = try await mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)
        let classResult = try await mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)

        XCTAssertNil(intResult)
        XCTAssertNil(stringResult)
        XCTAssertNil(structResult)
        XCTAssertNil(classResult)
    }

    func testCallingFunctionWithOptionalResultSupportsDifferentResultTypes() async throws {
        let user = User(name: "a user")
        let thing = Thing(name: "a thing")

        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _ in 123 }
        mock.registerResult(for: mock.functionWithOptionalStringResultRef) { _ in "a string" }
        mock.registerResult(for: \.functionWithOptionalStructResultRef) { _ in user }
        mock.registerResult(for: \.functionWithOptionalClassResultRef) { _ in thing }

        let intResult = try await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let stringResult = try await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let structResult = try await mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)
        let classResult = try await mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
        XCTAssertEqual(structResult, user)
        XCTAssertTrue(classResult === thing)
    }

    func testCallingFunctionWithOptionalResultCanRegisterDifferentReturnValuesForDifferentArgumentValues() async throws {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        let intResult = try await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let int2Result = try await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
        let stringResult = try await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let string2Result = try await mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(int2Result, 456)
        XCTAssertEqual(stringResult, "abc")
        XCTAssertEqual(string2Result, "def")
    }

    func testCallingFunctionWithOptionalResultRegistersCalls() async throws {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        _ = try await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        _ = try await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
        _ = try await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 789)
        _ = try await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        _ = try await mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

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

    func testCallingFunctionWithFallbackReturnsDefaultValueIfNoValueIsRegistered() async throws {
        let intResult = try await mock.call(mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)
        let stringResult = try await mock.call(mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")

        XCTAssertEqual(intResult, 456)
        XCTAssertEqual(stringResult, "def")
    }

    func testCallingFunctionWithFallbackReturnsRegisteredValueIfAValueIsRegistered() async throws {
        mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
        mock.registerResult(for: \.functionWithStringResultRef) { _ in "a string" }

        let intResult = try await mock.call(mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)
        let stringResult = try await mock.call(mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")

        XCTAssertEqual(intResult, 123)
        XCTAssertEqual(stringResult, "a string")
    }

    func testCallingFunctionWithVoidResultDoesNotFailWithPreconditionFailureIfNoResultIsRegistered() async throws {
        try await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
    }

    func testCallingFunctionWithVoidResultRegistersCalls() async throws {
        mock.registerResult(for: mock.functionWithVoidResultRef) { _, _ in }
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        try await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        try await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        try await mock.functionWithVoidResult(arg1: "abc", arg2: 789)

        let calls = mock.calls(to: mock.functionWithVoidResultRef)

        XCTAssertEqual(calls.count, 3)
        XCTAssertEqual(calls[0].arguments.0, "abc")
        XCTAssertEqual(calls[0].arguments.1, 123)
        XCTAssertEqual(calls[1].arguments.0, "abc")
        XCTAssertEqual(calls[1].arguments.1, 456)
        XCTAssertEqual(calls[2].arguments.0, "abc")
        XCTAssertEqual(calls[2].arguments.1, 789)
    }

    func testInspectingCallsRegistersAllCalls() async throws {
        mock.registerResult(for: mock.functionWithVoidResultRef) { _, _ in }

        try await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        try await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        try await mock.functionWithVoidResult(arg1: "abc", arg2: 789)

        let calls = mock.calls(to: mock.functionWithVoidResultRef)

        XCTAssertEqual(calls.count, 3)
    }

    func testInspectingCallsCanVerifyIfAtLeastOneCallHasBeenMade() async throws {
        mock.registerResult(for: mock.functionWithVoidResultRef) { _, _ in }

        XCTAssertFalse(mock.hasCalled(mock.functionWithVoidResultRef))
        try await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        XCTAssertTrue(mock.hasCalled(\.functionWithVoidResultRef))
        try await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        XCTAssertTrue(mock.hasCalled(mock.functionWithVoidResultRef))
    }

    func testInspectingCallsCanVerifyIfAnExactNumberOrCallsHaveBeenMade() async throws {
        mock.registerResult(for: \.functionWithVoidResultRef) { _,_ in }

        XCTAssertFalse(mock.hasCalled(mock.functionWithVoidResultRef, numberOfTimes: 2))
        try await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        XCTAssertFalse(mock.hasCalled(\.functionWithVoidResultRef, numberOfTimes: 2))
        try await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        XCTAssertTrue(mock.hasCalled(mock.functionWithVoidResultRef, numberOfTimes: 2))
    }

    func testResettingCallsCanResetAllCalls() async throws {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: \.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = try await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = try await mock.functionWithStringResult(arg1: "abc", arg2: 123)

        mock.resetCalls()

        XCTAssertFalse(mock.hasCalled(mock.functionWithIntResultRef))
        XCTAssertFalse(mock.hasCalled(\.functionWithStringResultRef))
    }

    func testResettingCalls_canResetAllCallsForACertainFunction() async throws {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = try await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = try await mock.functionWithStringResult(arg1: "abc", arg2: 123)

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
                try await testMock.functionWithVoidResult(arg1: "Test", arg2: index)
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
    lazy var functionWithIntResultRef = AsyncThrowingMockReference(functionWithIntResult)
    lazy var functionWithStringResultRef = AsyncThrowingMockReference(functionWithStringResult)
    lazy var functionWithStructResultRef = AsyncThrowingMockReference(functionWithStructResult)
    lazy var functionWithClassResultRef = AsyncThrowingMockReference(functionWithClassResult)
    lazy var functionWithOptionalIntResultRef = AsyncThrowingMockReference(functionWithOptionalIntResult)
    lazy var functionWithOptionalStringResultRef = AsyncThrowingMockReference(functionWithOptionalStringResult)
    lazy var functionWithOptionalStructResultRef = AsyncThrowingMockReference(functionWithOptionalStructResult)
    lazy var functionWithOptionalClassResultRef = AsyncThrowingMockReference(functionWithOptionalClassResult)
    lazy var functionWithVoidResultRef = AsyncThrowingMockReference(functionWithVoidResult)

    func functionWithIntResult(arg1: String, arg2: Int) async throws -> Int {
        try await call(functionWithIntResultRef, args: (arg1, arg2))
    }

    func functionWithStringResult(arg1: String, arg2: Int) async throws -> String {
        try await call(functionWithStringResultRef, args: (arg1, arg2))
    }

    func functionWithStructResult(arg1: String, arg2: Int) async throws -> User {
        try await call(functionWithStructResultRef, args: (arg1, arg2))
    }

    func functionWithClassResult(arg1: String, arg2: Int) async throws -> Thing {
        try await call(functionWithClassResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalIntResult(arg1: String, arg2: Int) async throws -> Int? {
        try await call(functionWithOptionalIntResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalStringResult(arg1: String, arg2: Int) async throws -> String? {
        try await call(functionWithOptionalStringResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalStructResult(arg1: String, arg2: Int) async throws -> User? {
        try await call(functionWithOptionalStructResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalClassResult(arg1: String, arg2: Int) async throws -> Thing? {
        try await call(functionWithOptionalClassResultRef, args: (arg1, arg2))
    }

    func functionWithVoidResult(arg1: String, arg2: Int) async throws {
        try await call(functionWithVoidResultRef, args: (arg1, arg2))
    }
}

private func assertThrowsAsyncError<T>(
    _ expression: () async throws -> T,
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        _ = try await expression()
        XCTFail("Expected expression to throw an error", file: file, line: line)
    } catch {}
}
