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
    
    func funcWithResult(arg: String) -> String {
        return invoke(funcWithResult, args: (arg))
    }
    
    func funcWithoutResult(arg: String) {
        invoke(funcWithoutResult, args: (arg))
    }
}

class MyMockViewController: UIViewController, MyProtocol {
    
    let recorder = Mock()
    
    func funcWithResult(arg: String) -> String {
        return recorder.invoke(funcWithResult, args: (arg))
    }
    
    func funcWithoutResult(arg: String) {
        recorder.invoke(funcWithoutResult, args: (arg))
    }
}
