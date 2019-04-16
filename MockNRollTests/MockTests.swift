//
//  MockTests.swift
//  MockNRollTests
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
import MockNRoll

class MockTests: QuickSpec {
    
    override func spec() {
        
        var mock: MockClass!
        
        beforeEach {
            mock = MockClass()
        }
        
        describe("invoking function with non-optional result") {
            
            it("it fails with precondition failure if no result is registered") {
                expect { _ = mock.functionWithIntResult(arg1: "abc", arg2: 123) }.to(throwAssertion())
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
                mock.registerResult(for: mock.functionWithIntResult) { arg1, arg2 in return arg2 }
                mock.registerResult(for: mock.functionWithStringResult) { arg1, arg2 in return arg1 }
                
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
                
                let intExecutions = mock.executions(of: mock.functionWithIntResult)
                let stringExecutions = mock.executions(of: mock.functionWithStringResult)
                expect(intExecutions.count).to(equal(3))
                expect(stringExecutions.count).to(equal(2))
                expect(intExecutions[0].arguments.0).to(equal("abc"))
                expect(intExecutions[0].arguments.1).to(equal(123))
                expect(intExecutions[1].arguments.0).to(equal("abc"))
                expect(intExecutions[1].arguments.1).to(equal(456))
                expect(intExecutions[2].arguments.0).to(equal("abc"))
                expect(intExecutions[2].arguments.1).to(equal(789))
                expect(stringExecutions[0].arguments.0).to(equal("abc"))
                expect(stringExecutions[0].arguments.1).to(equal(123))
                expect(stringExecutions[1].arguments.0).to(equal("def"))
                expect(stringExecutions[1].arguments.1).to(equal(123))
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
                mock.registerResult(for: mock.functionWithOptionalIntResult) { arg1, arg2 in return arg2 }
                mock.registerResult(for: mock.functionWithOptionalStringResult) { arg1, arg2 in return arg1 }
                
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
                
                let intExecutions = mock.executions(of: mock.functionWithOptionalIntResult)
                let stringExecutions = mock.executions(of: mock.functionWithOptionalStringResult)
                expect(intExecutions.count).to(equal(3))
                expect(stringExecutions.count).to(equal(2))
                expect(intExecutions[0].arguments.0).to(equal("abc"))
                expect(intExecutions[0].arguments.1).to(equal(123))
                expect(intExecutions[1].arguments.0).to(equal("abc"))
                expect(intExecutions[1].arguments.1).to(equal(456))
                expect(intExecutions[2].arguments.0).to(equal("abc"))
                expect(intExecutions[2].arguments.1).to(equal(789))
                expect(stringExecutions[0].arguments.0).to(equal("abc"))
                expect(stringExecutions[0].arguments.1).to(equal(123))
                expect(stringExecutions[1].arguments.0).to(equal("def"))
                expect(stringExecutions[1].arguments.1).to(equal(123))
            }
        }
        
        describe("invoking function with default result") {
            
            it("returns default value if no value is registered") {
                expect(mock.invoke(mock.functionWithIntResult, args: ("abc", 123), default: 456)).to(equal(456))
                expect(mock.invoke(mock.functionWithStringResult, args: ("abc", 123), default: "def")).to(equal("def"))
            }
            
            it("returns registered value if a value is registered") {
                mock.registerResult(for: mock.functionWithIntResult) { _ in return 123 }
                mock.registerResult(for: mock.functionWithStringResult) { _ in return "a string" }
                expect(mock.invoke(mock.functionWithIntResult, args: ("abc", 123), default: 456)).to(equal(123))
                expect(mock.invoke(mock.functionWithStringResult, args: ("abc", 123), default: "def")).to(equal("a string"))
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
                
                let voidExecutions = mock.executions(of: mock.functionWithVoidResult)
                expect(voidExecutions.count).to(equal(3))
                expect(voidExecutions[0].arguments.0).to(equal("abc"))
                expect(voidExecutions[0].arguments.1).to(equal(123))
                expect(voidExecutions[1].arguments.0).to(equal("abc"))
                expect(voidExecutions[1].arguments.1).to(equal(456))
                expect(voidExecutions[2].arguments.0).to(equal("abc"))
                expect(voidExecutions[2].arguments.1).to(equal(789))
            }
        }
    }
}
