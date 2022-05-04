//
//  TestProtocol.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-04-16.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Foundation

protocol TestProtocol {
    
    func functionWithIntResult(arg1: String, arg2: Int) -> Int
    func functionWithStringResult(arg1: String, arg2: Int) -> String
    func functionWithStructResult(arg1: String, arg2: Int) -> User
    func functionWithClassResult(arg1: String, arg2: Int) -> Thing
    
    func functionWithOptionalIntResult(arg1: String, arg2: Int) -> Int?
    func functionWithOptionalStringResult(arg1: String, arg2: Int) -> String?
    func functionWithOptionalStructResult(arg1: String, arg2: Int) -> User?
    func functionWithOptionalClassResult(arg1: String, arg2: Int) -> Thing?
    
    func functionWithVoidResult(arg1: String, arg2: Int)
    
    func asyncFunction(arg1: String, completion: @escaping (Error?) -> Void)
}

protocol AsyncTestProtocol {

    func functionWithIntResult(arg1: String, arg2: Int) async -> Int
    func functionWithStringResult(arg1: String, arg2: Int) async -> String
    func functionWithStructResult(arg1: String, arg2: Int) async -> User
    func functionWithClassResult(arg1: String, arg2: Int) async -> Thing

    func functionWithOptionalIntResult(arg1: String, arg2: Int) async -> Int?
    func functionWithOptionalStringResult(arg1: String, arg2: Int) async -> String?
    func functionWithOptionalStructResult(arg1: String, arg2: Int) async -> User?
    func functionWithOptionalClassResult(arg1: String, arg2: Int) async -> Thing?

    func functionWithVoidResult(arg1: String, arg2: Int) async
}

struct User: Equatable {
    
    var name: String
}

class Thing {
    
    init(name: String) {
        self.name = name
    }
    
    var name: String
}
