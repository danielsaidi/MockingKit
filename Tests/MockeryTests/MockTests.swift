//
//  MockTests.swift
//  MockeryTests
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
import Mockery

class MockTests: QuickSpec {

    override func spec() {
        
        var mock: MockClass!

        beforeEach {
            mock = MockClass()
        }
        
        describe("invoking function with non-optional result") {
            
            it("fails with precondition failure if no result is registered") {
                //expect { _ = mock.functionWithIntResult(arg1: "abc", arg2: 123) }.to(throwAssertion())
            }

            it("it supports different result types") {
                let user = User(name: "a user")
                let thing = Thing(name: "a thing")
                mock.registerResult(for: mock.functionWithIntResult) { _ in return 123 }
                mock.registerResult(for: mock.functionWithStringResult) { _ in return "a string" }
                mock.registerResult(for: mock.functionWithStructResult) { _ in return user }
                mock.registerResult(for: mock.functionWithClassResult) { _ in return thing }

                expect(mock.functionWithIntResult(arg1: "abc", arg2: 123)).to(equal(123))
                expect(mock.functionWithStringResult(arg1: "abc", arg2: 123)).to(equal("a string"))
                expect(mock.functionWithStructResult(arg1: "abc", arg2: 123)).to(equal(user))
                expect(mock.functionWithClassResult(arg1: "abc", arg2: 123)).to(be(thing))
            }

            it("it can register different return values for different argument values") {
                mock.registerResult(for: mock.functionWithIntResult) { _, arg2 in return arg2 }
                mock.registerResult(for: mock.functionWithStringResult) { arg1, _ in return arg1 }

                expect(mock.functionWithIntResult(arg1: "abc", arg2: 123)).to(equal(123))
                expect(mock.functionWithIntResult(arg1: "abc", arg2: 456)).to(equal(456))
                expect(mock.functionWithStringResult(arg1: "abc", arg2: 123)).to(equal("abc"))
                expect(mock.functionWithStringResult(arg1: "def", arg2: 123)).to(equal("def"))
            }

            it("it registers executions") {
                mock.registerResult(for: mock.functionWithIntResult) { _, arg2 in return arg2 }
                mock.registerResult(for: mock.functionWithStringResult) { arg1, _ in return arg1 }

                _ = mock.functionWithIntResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithIntResult(arg1: "abc", arg2: 456)
                _ = mock.functionWithIntResult(arg1: "abc", arg2: 789)
                _ = mock.functionWithStringResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithStringResult(arg1: "def", arg2: 123)

                let intInvokations = mock.invokations(of: mock.functionWithIntResult)
                let strInvokations = mock.invokations(of: mock.functionWithStringResult)
                expect(intInvokations.count).to(equal(3))
                expect(strInvokations.count).to(equal(2))
                expect(intInvokations[0].arguments.0).to(equal("abc"))
                expect(intInvokations[0].arguments.1).to(equal(123))
                expect(intInvokations[1].arguments.0).to(equal("abc"))
                expect(intInvokations[1].arguments.1).to(equal(456))
                expect(intInvokations[2].arguments.0).to(equal("abc"))
                expect(intInvokations[2].arguments.1).to(equal(789))
                expect(strInvokations[0].arguments.0).to(equal("abc"))
                expect(strInvokations[0].arguments.1).to(equal(123))
                expect(strInvokations[1].arguments.0).to(equal("def"))
                expect(strInvokations[1].arguments.1).to(equal(123))
            }
        }

        describe("invoking function with optional result") {

            it("doesn't fail with precondition failure if no result is registered") {
                expect(mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)).to(beNil())
                expect(mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)).to(beNil())
                expect(mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)).to(beNil())
                expect(mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)).to(beNil())
            }

            it("it supports different result types") {
                let user = User(name: "a user")
                let thing = Thing(name: "a thing")
                mock.registerResult(for: mock.functionWithOptionalIntResult) { _ in return 123 }
                mock.registerResult(for: mock.functionWithOptionalStringResult) { _ in return "a string" }
                mock.registerResult(for: mock.functionWithOptionalStructResult) { _ in return user }
                mock.registerResult(for: mock.functionWithOptionalClassResult) { _ in return thing }

                expect(mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)).to(equal(123))
                expect(mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)).to(equal("a string"))
                expect(mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)).to(equal(user))
                expect(mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)).to(be(thing))
            }

            it("it can register different return values for different argument values") {
                mock.registerResult(for: mock.functionWithOptionalIntResult) { _, arg2 in return arg2 }
                mock.registerResult(for: mock.functionWithOptionalStringResult) { arg1, _ in return arg1 }

                expect(mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)).to(equal(123))
                expect(mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)).to(equal(456))
                expect(mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)).to(equal("abc"))
                expect(mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)).to(equal("def"))
            }

            it("it registers executions") {
                mock.registerResult(for: mock.functionWithOptionalIntResult) { _, arg2 in return arg2 }
                mock.registerResult(for: mock.functionWithOptionalStringResult) { arg1, _ in return arg1 }

                _ = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
                _ = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 789)
                _ = mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)

                let intInvokations = mock.invokations(of: mock.functionWithOptionalIntResult)
                let strInvokations = mock.invokations(of: mock.functionWithOptionalStringResult)
                expect(intInvokations.count).to(equal(3))
                expect(strInvokations.count).to(equal(2))
                expect(intInvokations[0].arguments.0).to(equal("abc"))
                expect(intInvokations[0].arguments.1).to(equal(123))
                expect(intInvokations[1].arguments.0).to(equal("abc"))
                expect(intInvokations[1].arguments.1).to(equal(456))
                expect(intInvokations[2].arguments.0).to(equal("abc"))
                expect(intInvokations[2].arguments.1).to(equal(789))
                expect(strInvokations[0].arguments.0).to(equal("abc"))
                expect(strInvokations[0].arguments.1).to(equal(123))
                expect(strInvokations[1].arguments.0).to(equal("def"))
                expect(strInvokations[1].arguments.1).to(equal(123))
            }
        }

        describe("invoking function with fallback") {

            it("returns default value if no value is registered") {
                expect(mock.invoke(mock.functionWithIntResult, args: ("abc", 123), fallback: 456)).to(equal(456))
                expect(mock.invoke(mock.functionWithStringResult, args: ("abc", 123), fallback: "def")).to(equal("def"))
            }

            it("returns registered value if a value is registered") {
                mock.registerResult(for: mock.functionWithIntResult) { _ in return 123 }
                mock.registerResult(for: mock.functionWithStringResult) { _ in return "a string" }
                expect(mock.invoke(mock.functionWithIntResult, args: ("abc", 123), fallback: 456)).to(equal(123))
                expect(mock.invoke(mock.functionWithStringResult, args: ("abc", 123), fallback: "def")).to(equal("a string"))
            }
        }

        describe("invoking function with void result") {

            it("doesn't fail with precondition failure if no result is registered") {
                expect(mock.functionWithVoidResult(arg1: "abc", arg2: 123)).to(beVoid())
            }

            it("it registers executions") {
                mock.registerResult(for: mock.functionWithOptionalIntResult) { _, arg2 in return arg2 }
                mock.registerResult(for: mock.functionWithOptionalStringResult) { arg1, _ in return arg1 }

                _ = mock.functionWithVoidResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithVoidResult(arg1: "abc", arg2: 456)
                _ = mock.functionWithVoidResult(arg1: "abc", arg2: 789)

                let invokations = mock.invokations(of: mock.functionWithVoidResult)
                expect(invokations.count).to(equal(3))
                expect(invokations[0].arguments.0).to(equal("abc"))
                expect(invokations[0].arguments.1).to(equal(123))
                expect(invokations[1].arguments.0).to(equal("abc"))
                expect(invokations[1].arguments.1).to(equal(456))
                expect(invokations[2].arguments.0).to(equal("abc"))
                expect(invokations[2].arguments.1).to(equal(789))
            }
        }
        
        describe("inspecting invokations") {
            
            it("registers all invokations") {
                _ = mock.functionWithVoidResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithVoidResult(arg1: "abc", arg2: 456)
                _ = mock.functionWithVoidResult(arg1: "abc", arg2: 789)
                let invokations = mock.invokations(of: mock.functionWithVoidResult)
                expect(invokations.count).to(equal(3))
            }
            
            it("can verify if at least one invokation has been made") {
                expect(mock.hasInvoked(mock.functionWithVoidResult)).to(beFalse())
                _ = mock.functionWithVoidResult(arg1: "abc", arg2: 123)
                expect(mock.hasInvoked(mock.functionWithVoidResult)).to(beTrue())
                _ = mock.functionWithVoidResult(arg1: "abc", arg2: 456)
                expect(mock.hasInvoked(mock.functionWithVoidResult)).to(beTrue())
            }
            
            it("can verify if an exact number or invokations have been made") {
                expect(mock.hasInvoked(mock.functionWithVoidResult, numberOfTimes: 2)).to(beFalse())
                _ = mock.functionWithVoidResult(arg1: "abc", arg2: 123)
                expect(mock.hasInvoked(mock.functionWithVoidResult, numberOfTimes: 2)).to(beFalse())
                _ = mock.functionWithVoidResult(arg1: "abc", arg2: 456)
                expect(mock.hasInvoked(mock.functionWithVoidResult, numberOfTimes: 2)).to(beTrue())
            }
        }
    }
}
