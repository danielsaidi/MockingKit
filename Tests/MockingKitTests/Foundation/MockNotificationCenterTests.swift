//
//  MockNotificationCenterTests.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2020-08-03.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation
import Quick
import Nimble
import MockingKit

private class TestClass: NSObject {

    let id = UUID()
    
    @objc func testFunc() {}
}

class MockNotificationCenterTests: QuickSpec {

    override func spec() {
        
        var center: MockNotificationCenter!
        
        let name = Notification.Name("com.test.notification")
        let obj = TestClass()
        let info: [AnyHashable: Any] = ["key": "value"]
        
        beforeEach {
            center = MockNotificationCenter()
        }

        func value(_ value: Any?, is obj: TestClass) -> Bool {
            (value as? TestClass)?.id == obj.id
        }
        
        describe("mock notification center") {
            
            it("can mock adding observer with name") {
                let observer = TestClass()
                var blockExecution: Notification?
                let block: (Notification) -> Void = { notification in blockExecution = notification }
                let queue = OperationQueue.current
                center.registerResult(for: center.addObserverForNameRef) { _ in observer }
                let result = center.addObserver(forName: name, object: obj, queue: queue, using: block)
                let calls = center.calls(to: center.addObserverForNameRef).first
                expect(calls?.arguments.0).to(equal(name))
                expect(value(calls?.arguments.1, is: obj)).to(beTrue())
                expect(calls?.arguments.2).to(be(queue))
                calls?.arguments.3(Notification(name: name))
                expect(blockExecution?.name).to(equal(name))
                expect(calls?.result).to(be(observer))
                expect(result).to(be(observer))
            }
            
            it("can mock adding observer with selector") {
                let observer = TestClass()
                center.addObserver(observer, selector: #selector(observer.testFunc), name: name, object: obj)
                let call = center.calls(to: center.addObserverWithSelectorRef).first
                expect(value(call?.arguments.0, is: observer)).to(beTrue())
                expect(call?.arguments.1).toNot(beNil())
                expect(call?.arguments.2).to(equal(name))
                expect(value(call?.arguments.3, is: obj)).to(beTrue())
            }
            
            it("can mock posting notification") {
                center.post(Notification(name: name))
                let calls = center.calls(to: center.postNotificationRef).first
                expect(calls?.arguments.name).to(equal(name))
            }
            
            it("can mock posting notification with name, object and user info") {
                center.post(name: name, object: nil)
                center.post(name: name, object: obj)
                center.post(name: name, object: obj, userInfo: nil)
                center.post(name: name, object: obj, userInfo: info)
                let calls = center.calls(to: center.postNotificationNameRef)
                
                expect(calls.count).to(equal(4))
                
                expect(calls[0].arguments.0).to(equal(name))
                expect(calls[0].arguments.1).to(beNil())
                expect(calls[0].arguments.2).to(beNil())
                
                expect(calls[1].arguments.0).to(equal(name))
                expect(value(calls[1].arguments.1, is: obj)).to(beTrue())
                expect(calls[1].arguments.2).to(beNil())
                
                expect(calls[2].arguments.0).to(equal(name))
                expect(value(calls[1].arguments.1, is: obj)).to(beTrue())
                expect(calls[2].arguments.2).to(beNil())
                
                expect(calls[3].arguments.0).to(equal(name))
                expect(value(calls[1].arguments.1, is: obj)).to(beTrue())
                expect(calls[3].arguments.2?["key"] as? String).to(equal("value"))
            }
        }
        
        it("can mock removing observer") {
            let observer = TestClass()
            center.removeObserver(observer)
            center.removeObserver(observer, name: name, object: obj)
            
            let calls = center.calls(to: center.removeObserverRef)
            
            expect(calls.count).to(equal(2))

            expect(value(calls[0].arguments.0, is: observer)).to(beTrue())
            expect(calls[0].arguments.1).to(beNil())
            expect(calls[0].arguments.2).to(beNil())
            
            expect(value(calls[1].arguments.0, is: observer)).to(beTrue())
            expect(calls[1].arguments.1).to(equal(name))
            expect(value(calls[1].arguments.2, is: obj)).to(beTrue())
        }
    }
}
