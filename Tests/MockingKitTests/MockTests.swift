//
//  MockTests.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
@testable import MockingKit

class MockTests: QuickSpec {
    
    override func spec() {
        
        var mock: TestClass!

        beforeEach {
            mock = TestClass()
        }
        
        describe("registering result") {
            
            it("registers function with reference id") {
                let ref = mock.functionWithIntResultRef
                let result: (String, Int) throws -> Int = { str, int in int * 2 }
                mock.registerResult(for: ref, result: result)
                let obj = mock.registeredResults[ref.id]
                expect(obj).toNot(beNil())
            }
        }
        
        describe("invoking function with non-optional result") {
            
            it("fails with precondition failure if no result is registered") {
                expect { _ = mock.functionWithIntResult(arg1: "abc", arg2: 123) }.to(throwAssertion())
            }
            
            it("it supports different result types") {
                let user = User(name: "a user")
                let thing = Thing(name: "a thing")
                mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
                mock.registerResult(for: mock.functionWithStringResultRef) { _ in "a string" }
                mock.registerResult(for: mock.functionWithStructResultRef) { _ in user }
                mock.registerResult(for: mock.functionWithClassResultRef) { _ in thing }
                
                expect(mock.functionWithIntResult(arg1: "abc", arg2: 123)).to(equal(123))
                expect(mock.functionWithStringResult(arg1: "abc", arg2: 123)).to(equal("a string"))
                expect(mock.functionWithStructResult(arg1: "abc", arg2: 123)).to(equal(user))
                expect(mock.functionWithClassResult(arg1: "abc", arg2: 123)).to(be(thing))
            }
            
            it("it can register different return values for different argument values") {
                mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
                mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }
                
                expect(mock.functionWithIntResult(arg1: "abc", arg2: 123)).to(equal(123))
                expect(mock.functionWithIntResult(arg1: "abc", arg2: 456)).to(equal(456))
                expect(mock.functionWithStringResult(arg1: "abc", arg2: 123)).to(equal("abc"))
                expect(mock.functionWithStringResult(arg1: "def", arg2: 123)).to(equal("def"))
            }
            
            it("it registers invokations") {
                mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
                mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }
                
                _ = mock.functionWithIntResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithIntResult(arg1: "abc", arg2: 456)
                _ = mock.functionWithIntResult(arg1: "abc", arg2: 789)
                _ = mock.functionWithStringResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithStringResult(arg1: "def", arg2: 123)
                
                let intInvokations = mock.calls(to: mock.functionWithIntResultRef)
                let strInvokations = mock.calls(to: mock.functionWithStringResultRef)
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
                mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _ in 123 }
                mock.registerResult(for: mock.functionWithOptionalStringResultRef) { _ in "a string" }
                mock.registerResult(for: mock.functionWithOptionalStructResultRef) { _ in user }
                mock.registerResult(for: mock.functionWithOptionalClassResultRef) { _ in thing }
                
                expect(mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)).to(equal(123))
                expect(mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)).to(equal("a string"))
                expect(mock.functionWithOptionalStructResult(arg1: "abc", arg2: 123)).to(equal(user))
                expect(mock.functionWithOptionalClassResult(arg1: "abc", arg2: 123)).to(be(thing))
            }
            
            it("it can register different return values for different argument values") {
                mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
                mock.registerResult(for: mock.functionWithOptionalStringResultRef) { arg1, _ in arg1 }
                
                expect(mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)).to(equal(123))
                expect(mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)).to(equal(456))
                expect(mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)).to(equal("abc"))
                expect(mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)).to(equal("def"))
            }
            
            it("it registers invokations") {
                mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
                mock.registerResult(for: mock.functionWithOptionalStringResultRef) { arg1, _ in arg1 }
                
                _ = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 456)
                _ = mock.functionWithOptionalIntResult(arg1: "abc", arg2: 789)
                _ = mock.functionWithOptionalStringResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithOptionalStringResult(arg1: "def", arg2: 123)
                
                let intInvokations = mock.calls(to: mock.functionWithOptionalIntResultRef)
                let strInvokations = mock.calls(to: mock.functionWithOptionalStringResultRef)
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
                expect(mock.call(mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)).to(equal(456))
                expect(mock.call(mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")).to(equal("def"))
            }
            
            it("returns registered value if a value is registered") {
                mock.registerResult(for: mock.functionWithIntResultRef) { _ in 123 }
                mock.registerResult(for: mock.functionWithStringResultRef) { _ in "a string" }
                expect(mock.call(mock.functionWithIntResultRef, args: ("abc", 123), fallback: 456)).to(equal(123))
                expect(mock.call(mock.functionWithStringResultRef, args: ("abc", 123), fallback: "def")).to(equal("a string"))
            }
        }
        
        describe("invoking function with void result") {
            
            it("doesn't fail with precondition failure if no result is registered") {
                expect(mock.functionWithVoidResult(arg1: "abc", arg2: 123)).to(beVoid())
            }
            
            it("it registers invokations") {
                mock.registerResult(for: mock.functionWithOptionalIntResultRef) { _, arg2 in arg2 }
                mock.registerResult(for: mock.functionWithOptionalStringResultRef) { arg1, _ in arg1 }
                
                mock.functionWithVoidResult(arg1: "abc", arg2: 123)
                mock.functionWithVoidResult(arg1: "abc", arg2: 456)
                mock.functionWithVoidResult(arg1: "abc", arg2: 789)
                
                let invokations = mock.calls(to: mock.functionWithVoidResultRef)
                expect(invokations.count).to(equal(3))
                expect(invokations[0].arguments.0).to(equal("abc"))
                expect(invokations[0].arguments.1).to(equal(123))
                expect(invokations[1].arguments.0).to(equal("abc"))
                expect(invokations[1].arguments.1).to(equal(456))
                expect(invokations[2].arguments.0).to(equal("abc"))
                expect(invokations[2].arguments.1).to(equal(789))
            }
        }
        
        describe("invoking async function") {
            
            it("it registers invokations") {
                mock.asyncFunction(arg1: "async", completion: { _ in })
                
                let invokations = mock.calls(to: mock.asyncFunctionRef)
                expect(invokations.count).to(equal(1))
                expect(invokations[0].arguments.0).to(equal("async"))
            }
        }
        
        describe("inspecting invokations") {
            
            it("registers all invokations") {
                mock.functionWithVoidResult(arg1: "abc", arg2: 123)
                mock.functionWithVoidResult(arg1: "abc", arg2: 456)
                mock.functionWithVoidResult(arg1: "abc", arg2: 789)
                let invokations = mock.calls(to: mock.functionWithVoidResultRef)
                expect(invokations.count).to(equal(3))
            }
            
            it("can verify if at least one invokation has been made") {
                expect(mock.hasCalled(mock.functionWithVoidResultRef)).to(beFalse())
                mock.functionWithVoidResult(arg1: "abc", arg2: 123)
                expect(mock.hasCalled(mock.functionWithVoidResultRef)).to(beTrue())
                mock.functionWithVoidResult(arg1: "abc", arg2: 456)
                expect(mock.hasCalled(mock.functionWithVoidResultRef)).to(beTrue())
            }
            
            it("can verify if an exact number or invokations have been made") {
                expect(mock.hasCalled(mock.functionWithVoidResultRef, times: 2)).to(beFalse())
                mock.functionWithVoidResult(arg1: "abc", arg2: 123)
                expect(mock.hasCalled(mock.functionWithVoidResultRef, times: 2)).to(beFalse())
                mock.functionWithVoidResult(arg1: "abc", arg2: 456)
                expect(mock.hasCalled(mock.functionWithVoidResultRef, times: 2)).to(beTrue())
            }
        }
        
        describe("resetting invokations") {
            
            it("can reset all invokations") {
                mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
                mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }
                _ = mock.functionWithIntResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithStringResult(arg1: "abc", arg2: 123)
                mock.resetCalls()
                expect(mock.hasCalled(mock.functionWithIntResultRef)).to(beFalse())
                expect(mock.hasCalled(mock.functionWithStringResultRef)).to(beFalse())
            }
            
            it("can reset all invokations for a certain function") {
                mock.registerResult(for: mock.functionWithIntResultRef) { _, arg2 in arg2 }
                mock.registerResult(for: mock.functionWithStringResultRef) { arg1, _ in arg1 }
                _ = mock.functionWithIntResult(arg1: "abc", arg2: 123)
                _ = mock.functionWithStringResult(arg1: "abc", arg2: 123)
                mock.resetCalls(to: mock.functionWithIntResultRef)
                expect(mock.hasCalled(mock.functionWithIntResultRef)).to(beFalse())
                expect(mock.hasCalled(mock.functionWithStringResultRef)).to(beTrue())
            }
        }
    }
}

private class TestClass: Mock, TestProtocol {
    
    lazy var functionWithIntResultRef = MockReference(functionWithIntResult)
    lazy var functionWithStringResultRef = MockReference(functionWithStringResult)
    lazy var functionWithStructResultRef = MockReference(functionWithStructResult)
    lazy var functionWithClassResultRef = MockReference(functionWithClassResult)
    lazy var functionWithOptionalIntResultRef = MockReference(functionWithOptionalIntResult)
    lazy var functionWithOptionalStringResultRef = MockReference(functionWithOptionalStringResult)
    lazy var functionWithOptionalStructResultRef = MockReference(functionWithOptionalStructResult)
    lazy var functionWithOptionalClassResultRef = MockReference(functionWithOptionalClassResult)
    lazy var functionWithVoidResultRef = MockReference(functionWithVoidResult)
    lazy var asyncFunctionRef = MockReference(asyncFunction)
    
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

    func asyncFunction(arg1: String, completion: @escaping (Error?) -> Void) {
        call(asyncFunctionRef, args: escaping(arg1, completion))
    }
}
