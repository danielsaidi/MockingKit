//
//  ViewController.swift
//  MockeryDemo
//
//  Created by Daniel Saidi on 2019-08-21.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let result = testMock() + testMockRecorder()
        print(result)
        alert(result)
    }
    
    func alert(_ result: String) {
        let alert = UIAlertController(title: "Test Result", message: result, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        present(alert, animated: true)
    }
    
    func testMock() -> String {
        let mock = MyMock()
        mock.registerResult(for: mock.funcWithResult) { arg in String(arg.reversed()) }
        let result1 = mock.funcWithResult(arg: "Call 1")
        let result2 = mock.funcWithResult(arg: "Call 2")
        mock.funcWithoutResult(arg: "Call 3")
        let resultExecutions = mock.executions(of: mock.funcWithResult)
        let voidExecutions = mock.executions(of: mock.funcWithoutResult)
        
        return """
        
******************
MyMock Test Result
******************
        
result1: \(result1)
result2: \(result2)
funcWithResult calls: \(resultExecutions.count)
funcWithResult args: \(resultExecutions.map { $0.arguments }.joined(separator: ", "))
funcWithResult results: \(resultExecutions.map { $0.result }.joined(separator: ", "))
funcWithoutResult calls: \(voidExecutions.count)
funcWithoutResult args: \(voidExecutions.map { $0.arguments }.joined(separator: ", "))
        
"""
    }
    
    func testMockRecorder() -> String {
        let mock = MyMockViewController()
        mock.recorder.registerResult(for: mock.funcWithResult) { arg in String(arg.reversed()) }
        let result1 = mock.funcWithResult(arg: "Call 1")
        let result2 = mock.funcWithResult(arg: "Call 2")
        mock.funcWithoutResult(arg: "Call 3")
        let resultExecutions = mock.recorder.executions(of: mock.funcWithResult)
        let voidExecutions = mock.recorder.executions(of: mock.funcWithoutResult)
        
        return """
        
******************
MyMock Test Result
******************
        
result1: \(result1)
result2: \(result2)
funcWithResult calls: \(resultExecutions.count)
funcWithResult args: \(resultExecutions.map { $0.arguments }.joined(separator: ", "))
funcWithResult results: \(resultExecutions.map { $0.result }.joined(separator: ", "))
funcWithoutResult calls: \(voidExecutions.count)
funcWithoutResult args: \(voidExecutions.map { $0.arguments }.joined(separator: ", "))
        
"""
    }


}

