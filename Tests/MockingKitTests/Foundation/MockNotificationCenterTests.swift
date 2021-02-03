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
        
        describe("mock notification center") {
            
            it("can mock adding observer with name") {
                let observer = TestClass()
                var blockExecution: Notification?
                let block: (Notification) -> Void = { notification in blockExecution = notification }
                let queue = OperationQueue.current
                center.registerResult(for: center.addObserverForNameRef) { _ in observer }
                let result = center.addObserver(forName: name, object: obj, queue: queue, using: block)
                let inv = center.calls(to: center.addObserverForNameRef).first
                expect(inv?.arguments.0).to(equal(name))
                expect(inv?.arguments.1).to(be(obj))
                expect(inv?.arguments.2).to(be(queue))
                inv?.arguments.3(Notification(name: name))
                expect(blockExecution?.name).to(equal(name))
                expect(inv?.result).to(be(observer))
                expect(result).to(be(observer))
            }
            
            it("can mock adding observer with selector") {
                let observer = TestClass()
                center.addObserver(observer, selector: #selector(observer.testFunc), name: name, object: obj)
                let inv = center.calls(to: center.addObserverWithSelectorRef).first
                expect(inv?.arguments.0).to(be(observer))
                expect(inv?.arguments.1).toNot(beNil())
                expect(inv?.arguments.2).to(equal(name))
                expect(inv?.arguments.3).to(be(obj))
            }
            
            it("can mock posting notification") {
                center.post(Notification(name: name))
                let inv = center.calls(to: center.postNotificationRef).first
                expect(inv?.arguments.name).to(equal(name))
            }
            
            it("can mock posting notification with name, object and user info") {
                center.post(name: name, object: nil)
                center.post(name: name, object: obj)
                center.post(name: name, object: obj, userInfo: nil)
                center.post(name: name, object: obj, userInfo: info)
                let inv = center.calls(to: center.postNotificationNameRef)
                
                expect(inv.count).to(equal(4))
                
                expect(inv[0].arguments.0).to(equal(name))
                expect(inv[0].arguments.1).to(beNil())
                expect(inv[0].arguments.2).to(beNil())
                
                expect(inv[1].arguments.0).to(equal(name))
                expect(inv[1].arguments.1).to(be(obj))
                expect(inv[1].arguments.2).to(beNil())
                
                expect(inv[2].arguments.0).to(equal(name))
                expect(inv[2].arguments.1).to(be(obj))
                expect(inv[2].arguments.2).to(beNil())
                
                expect(inv[3].arguments.0).to(equal(name))
                expect(inv[3].arguments.1).to(be(obj))
                expect(inv[3].arguments.2?["key"] as? String).to(equal("value"))
            }
        }
        
        it("can mock removing observer") {
            let observer = TestClass()
            center.removeObserver(observer)
            center.removeObserver(observer, name: name, object: obj)
            
            let inv = center.calls(to: center.removeObserverRef)
            
            expect(inv.count).to(equal(2))
            
            expect(inv[0].arguments.0).to(be(observer))
            expect(inv[0].arguments.1).to(beNil())
            expect(inv[0].arguments.2).to(beNil())
            
            expect(inv[1].arguments.0).to(be(observer))
            expect(inv[1].arguments.1).to(equal(name))
            expect(inv[1].arguments.2).to(be(obj))
        }
    }
}
