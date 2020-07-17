//
//  Mocks.swift
//  MockeryDemo
//
//  Created by Daniel Saidi on 2019-08-22.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import Mockery
import UIKit

protocol MyProtocol {
    
    func funcWithResult(arg: String) -> String
    func funcWithoutResult(arg: String) -> Void
}

class MyMock: Mock, MyProtocol {
    
    lazy var funcWithResultRef = MockReference(funcWithResult)
    lazy var funcWithoutResultRef = MockReference(funcWithoutResult)
    
    func funcWithResult(arg: String) -> String {
        invoke(funcWithResultRef, args: (arg))
    }
    
    func funcWithoutResult(arg: String) {
        invoke(funcWithoutResultRef, args: (arg))
    }
}

class MyMockViewController: UIViewController, MyProtocol {
    
    let recorder = Mock()
    
    lazy var funcWithResultRef = MockReference(funcWithResult)
    lazy var funcWithoutResultRef = MockReference(funcWithoutResult)
    
    func funcWithResult(arg: String) -> String {
        recorder.invoke(funcWithResultRef, args: (arg))
    }
    
    func funcWithoutResult(arg: String) {
        recorder.invoke(funcWithoutResultRef, args: (arg))
    }
}
