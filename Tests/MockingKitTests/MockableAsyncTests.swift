//
//  MockableAsyncTests.swift
//
//  Created by Tobias Boogh on 2022-05-04.
//

import XCTest
import Nimble
@testable import MockingKit

class MockableAsyncTests: XCTestCase {

    fileprivate var mock: TestClass!

    override func setUp() {
        mock = TestClass()
    }

    func testRegisteringResult_registersFunctionWithReferenceId() {
        let ref = mock.functionWithIntResultRef
        let result: (String, Int) throws -> Int = { _, int in int * 2 }
        mock.registerResult(for: ref, result: result)
        let obj = mock.mock.registeredResults[ref.id]
        expect(obj).toNot(beNil())
    }

    func testCallingAFunctionWithNonOptionalResult_itSupportsDifferentResultTypes() async {

        let user = User(name: "a user")
        let thing = Thing(name: "a thing")
        mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
        mock.registerResult(for: mock.functionWithStringResultRef) { _ in "a string" }
        mock.registerResult(for: mock.functionWithStructResultRef) { _ in user }
        mock.registerResult(for: mock.functionWithClassResultRef) { _ in thing }

        let intResult = await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        let stringResult = await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        let structResult = await mock.functionWithStructResult(arg1: "abc", arg2: 123)
        let classResult = await mock.functionWithClassResult(arg1: "abc", arg2: 123)

        expect(intResult).to(equal(123))
        expect(stringResult).to(equal("a string"))
        expect(structResult).to(equal(user))
        expect(classResult).to(be(thing))
    }

    func testCallingAFunctionWithNonOptionalResult_itCanRegisterDifferentReturnValuesForDifferentArgumentValues() async {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }

        let intResult = await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        let int2Result = await mock.functionWithIntResult(arg1: "abc", arg2: 456)
        let stringResult = await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        let string2Result = await mock.functionWithStringResult(arg1: "def", arg2: 123)

        expect(intResult).to(equal(123))
        expect(int2Result).to(equal(456))
        expect(stringResult).to(equal("abc"))
        expect(string2Result).to(equal("def"))
    }

    func testCallingAFunctionWithNonOptionalResult_itRegistersCalls() async {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }

        _ = await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithIntResult(arg1: "abc", arg2: 456)
        _ = await mock.functionWithIntResult(arg1: "abc", arg2: 789)
        _ = await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithStringResult(arg1: "def", arg2: 123)

        let intCalls = mock.calls(to: mock.functionWithIntResultRef)
        let strCalls = mock.calls(to: mock.functionWithStringResultRef)
        expect(intCalls.count).to(equal(3))
        expect(strCalls.count).to(equal(2))
        expect(intCalls[0].arguments.0).to(equal("abc"))
        expect(intCalls[0].arguments.1).to(equal(123))
        expect(intCalls[1].arguments.0).to(equal("abc"))
        expect(intCalls[1].arguments.1).to(equal(456))
        expect(intCalls[2].arguments.0).to(equal("abc"))
        expect(intCalls[2].arguments.1).to(equal(789))
        expect(strCalls[0].arguments.0).to(equal("abc"))
        expect(strCalls[0].arguments.1).to(equal(123))
        expect(strCalls[1].arguments.0).to(equal("def"))
        expect(strCalls[1].arguments.1).to(equal(123))
    }

    func testCallingAFunctionWithOptionalResult_doesNotFailWithPreconditionFailureIfNoResultIsRegistered() async {
        let intResult = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let stringResult = await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let structResult = await mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)
        let classResult = await mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)

        expect(intResult).to(beNil())
        expect(stringResult).to(beNil())
        expect(structResult).to(beNil())
        expect(classResult).to(beNil())
    }

    func testCallingAFunctionWithOptionalResult_itSupportsDifferentResultTypes() async {
        let user = User(name: "a user")
        let thing = Thing(name: "a thing")
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _ in 123 }
        mock.registerResult(for: mock.functionWithOptionalStringResultRef) { _ in "a string" }
        mock.registerResult(for: mock.functionWithOptionalStructResultRef) { _ in user }
        mock.registerResult(for: mock.functionWithOptionalClassResultRef) { _ in thing }

        let intResult = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let stringResult = await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let structResult = await mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)
        let classResult = await mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)

        expect(intResult).to(equal(123))
        expect(stringResult).to(equal("a string"))
        expect(structResult).to(equal(user))
        expect(classResult).to(be(thing))
    }

    func testCallingAFunctionWithOptionalResult_itCanRegisterDifferentReturnValuesForDifferentArgumentValues() async {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: mock.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        let intResult = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        let int2Result = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
        let stringResult = await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        let string2Result = await mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

        expect(intResult).to(equal(123))
        expect(int2Result).to(equal(456))
        expect(stringResult).to(equal("abc"))
        expect(string2Result).to(equal("def"))
    }
    func testCallingAFunctionWithOptionalResult_itRegistersCalls() async {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: mock.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        _ = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
        _ = await mock.functionWithOptionalIntResult(arg1: "abc", arg2: 789)
        _ = await mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

        let intCalls = mock.calls(to: mock.functionWithOptionalIntResultRef)
        let strCalls = mock.calls(to: mock.functionWithOptionalStringResultRef)
        expect(intCalls.count).to(equal(3))
        expect(strCalls.count).to(equal(2))
        expect(intCalls[0].arguments.0).to(equal("abc"))
        expect(intCalls[0].arguments.1).to(equal(123))
        expect(intCalls[1].arguments.0).to(equal("abc"))
        expect(intCalls[1].arguments.1).to(equal(456))
        expect(intCalls[2].arguments.0).to(equal("abc"))
        expect(intCalls[2].arguments.1).to(equal(789))
        expect(strCalls[0].arguments.0).to(equal("abc"))
        expect(strCalls[0].arguments.1).to(equal(123))
        expect(strCalls[1].arguments.0).to(equal("def"))
        expect(strCalls[1].arguments.1).to(equal(123))
    }

    func testCallingAFunctionWithFallback_ReturnsDefaultValueIfNoValueIsRegistered() async {
        let intResult = await mock.call(self.mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)
        let stringResult = await mock.call(self.mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")

        expect(intResult).to(equal(456))
        expect(stringResult).to(equal("def"))
    }

    func testCallingAFunctionWithFallback_ReturnsRegisteredValueIfAValueIsRegistered() async {
        self.mock.registerResult(for: self.mock.functionWithIntResultRef) { _ in 123 }
        self.mock.registerResult(for: self.mock.functionWithStringResultRef) { _ in "a string" }

        let intResult = await mock.call(self.mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)
        let stringResult = await mock.call(self.mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")

        expect(intResult).to(equal(123))
        expect(stringResult).to(equal("a string"))
    }

    func testCallingAFunctionWithVoidResult_doesNotFailWithPreconditionFailureIfNoResultIsRegistered() async {
        await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
    }

    func testCallingAFunctionWithVoidResult_itRegistersCalls() async {
        mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: mock.functionWithOptionalStringResultRef) { arg1, _ in arg1 }

        await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        await mock.functionWithVoidResult(arg1: "abc", arg2: 789)

        let calls = mock.calls(to: mock.functionWithVoidResultRef)
        expect(calls.count).to(equal(3))
        expect(calls[0].arguments.0).to(equal("abc"))
        expect(calls[0].arguments.1).to(equal(123))
        expect(calls[1].arguments.0).to(equal("abc"))
        expect(calls[1].arguments.1).to(equal(456))
        expect(calls[2].arguments.0).to(equal("abc"))
        expect(calls[2].arguments.1).to(equal(789))
    }


    func testInspectingCalls_RegistersAllCalls() async {
        await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        await mock.functionWithVoidResult(arg1: "abc", arg2: 789)
        let calls = mock.calls(to: mock.functionWithVoidResultRef)
        expect(calls.count).to(equal(3))
    }

    func testInspectingCalls_canVerifyIfAtLeastOneCallHasBeenMade() async {
        expect(self.mock.hasCalled(self.mock.functionWithVoidResultRef)).to(beFalse())
        await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        expect(self.mock.hasCalled(self.mock.functionWithVoidResultRef)).to(beTrue())
        await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        expect(self.mock.hasCalled(self.mock.functionWithVoidResultRef)).to(beTrue())
    }

    func testInspectingCalls_CanVerifyIfAnExactNumberOrCallsHaveBeenMade() async {
        expect(self.mock.hasCalled(self.mock.functionWithVoidResultRef, numberOfTimes: 2)).to(beFalse())
        await mock.functionWithVoidResult(arg1: "abc", arg2: 123)
        expect(self.mock.hasCalled(self.mock.functionWithVoidResultRef, numberOfTimes: 2)).to(beFalse())
        await mock.functionWithVoidResult(arg1: "abc", arg2: 456)
        expect(self.mock.hasCalled(self.mock.functionWithVoidResultRef, numberOfTimes: 2)).to(beTrue())
    }

    func testResettingCalls_CanResetAllCalls() async {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }
        _ = await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        mock.resetCalls()
        expect(self.mock.hasCalled(self.mock.functionWithIntResultRef)).to(beFalse())
        expect(self.mock.hasCalled(self.mock.functionWithStringResultRef)).to(beFalse())
    }

    func testResettingCalls_canResetAllCallsForACertainFunction() async {
        mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
        mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }
        _ = await mock.functionWithIntResult(arg1: "abc", arg2: 123)
        _ = await mock.functionWithStringResult(arg1: "abc", arg2: 123)
        mock.resetCalls(to: mock.functionWithIntResultRef)
        expect(self.mock.hasCalled(self.mock.functionWithIntResultRef)).to(beFalse())
        expect(self.mock.hasCalled(self.mock.functionWithStringResultRef)).to(beTrue())
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
