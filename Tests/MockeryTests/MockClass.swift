//
//  MockClass.swift
//  MockeryTests
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Mockery

class MockClass: Mock, MockProtocol {
    
    func functionWithIntResult(arg1: String, arg2: Int) -> Int {
        return invoke(functionWithIntResult, args: (arg1, arg2))
    }
    
    func functionWithStringResult(arg1: String, arg2: Int) -> String {
        return invoke(functionWithStringResult, args: (arg1, arg2))
    }
    
    func functionWithStructResult(arg1: String, arg2: Int) -> User {
        return invoke(functionWithStructResult, args: (arg1, arg2))
    }
    
    func functionWithClassResult(arg1: String, arg2: Int) -> Thing {
        return invoke(functionWithClassResult, args: (arg1, arg2))
    }
    
    
    func functionWithOptionalIntResult(arg1: String, arg2: Int) -> Int? {
        return invoke(functionWithOptionalIntResult, args: (arg1, arg2))
    }
    
    func functionWithOptionalStringResult(arg1: String, arg2: Int) -> String? {
        return invoke(functionWithOptionalStringResult, args: (arg1, arg2))
    }
    
    func functionWithOptionalStructResult(arg1: String, arg2: Int) -> User? {
        return invoke(functionWithOptionalStructResult, args: (arg1, arg2))
    }
    
    func functionWithOptionalClassResult(arg1: String, arg2: Int) -> Thing? {
        return invoke(functionWithOptionalClassResult, args: (arg1, arg2))
    }
    
    
    func functionWithVoidResult(arg1: String, arg2: Int) {
        invoke(functionWithVoidResult, args: (arg1, arg2))
    }
    
    func asyncFunction(arg1: String, completion: @escaping (Error?) -> Void) {
        invoke(asyncFunction, args: escaping(arg1, completion))
    }
}
