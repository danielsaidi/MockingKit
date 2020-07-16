//
//  TestMock.swift
//  MockeryTests
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Mockery

class TestMock: Mock, TestProtocol {
    
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
        try! invoke(functionWithIntResultRef, args: (arg1, arg2))
    }
    
    func functionWithStringResult(arg1: String, arg2: Int) -> String {
        try! invoke(functionWithStringResultRef, args: (arg1, arg2))
    }

    func functionWithStructResult(arg1: String, arg2: Int) -> User {
        try! invoke(functionWithStructResultRef, args: (arg1, arg2))
    }

    func functionWithClassResult(arg1: String, arg2: Int) -> Thing {
        try! invoke(functionWithClassResultRef, args: (arg1, arg2))
    }


    func functionWithOptionalIntResult(arg1: String, arg2: Int) -> Int? {
        try! invoke(functionWithOptionalIntResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalStringResult(arg1: String, arg2: Int) -> String? {
        try! invoke(functionWithOptionalStringResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalStructResult(arg1: String, arg2: Int) -> User? {
        try! invoke(functionWithOptionalStructResultRef, args: (arg1, arg2))
    }

    func functionWithOptionalClassResult(arg1: String, arg2: Int) -> Thing? {
        try! invoke(functionWithOptionalClassResultRef, args: (arg1, arg2))
    }


    func functionWithVoidResult(arg1: String, arg2: Int) {
        try! invoke(functionWithVoidResultRef, args: (arg1, arg2))
    }

    func asyncFunction(arg1: String, completion: @escaping (Error?) -> Void) {
        try! invoke(asyncFunctionRef, args: escaping(arg1, completion))
    }
}
