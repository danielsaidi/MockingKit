//
//  MockNotificationCenterTests.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2020-08-03.
//  Copyright © 2020-2024 Daniel Saidi. All rights reserved.
//

import Foundation
import MockingKit
import XCTest

final class MockNotificationCenterTests: XCTestCase {

    private var center: MockNotificationCenter!
    private var obj: TestClass!

    private let notification = Notification.Name("com.test.notification")
    private let info: [AnyHashable: Any] = ["key": "value"]

    override func setUp() {
        center = MockNotificationCenter()
        obj = TestClass()
    }

    private func value(_ value: Any?, is obj: TestClass) -> Bool {
        (value as? TestClass)?.id == obj.id
    }

    func testCanMockAddingObserverWithName() {
        let observer = TestClass()
        var blockExecution: Notification?
        let block: (Notification) -> Void = { notification in blockExecution = notification }
        let queue = OperationQueue.current
        center.registerResult(for: center.addObserverForNameRef) { _ in observer }
        let result = center.addObserver(forName: notification, object: obj, queue: queue, using: block)
        let calls = center.calls(to: center.addObserverForNameRef).first
        XCTAssertEqual(calls?.arguments.0, notification)
        XCTAssertTrue(value(calls?.arguments.1, is: obj))
        XCTAssertTrue(calls?.arguments.2 === queue)
        calls?.arguments.3(Notification(name: notification))
        XCTAssertEqual(blockExecution?.name, notification)
        XCTAssertTrue(calls?.result === observer)
        XCTAssertTrue(result === observer)
    }

    func testCanMockAddingObserverWithSelector() {
        let observer = TestClass()
        center.addObserver(observer, selector: #selector(observer.testFunc), name: notification, object: obj)
        let call = center.calls(to: center.addObserverWithSelectorRef).first
        XCTAssertTrue(value(call?.arguments.0, is: observer))
        XCTAssertNotNil(call?.arguments.1)
        XCTAssertEqual(call?.arguments.2, notification)
        XCTAssertTrue(value(call?.arguments.3, is: obj))
    }

    func testCanMockPostingNotification() {
        center.post(Notification(name: notification))
        let calls = center.calls(to: center.postNotificationRef).first
        XCTAssertEqual(calls?.arguments.name, notification)
    }

    func testCanMockPostingNotificationWithData() {
        center.post(name: notification, object: nil)
        center.post(name: notification, object: obj)
        center.post(name: notification, object: obj, userInfo: nil)
        center.post(name: notification, object: obj, userInfo: info)
        let calls = center.calls(to: center.postNotificationNameRef)

        XCTAssertEqual(calls.count, 4)

        XCTAssertEqual(calls[0].arguments.0, notification)
        XCTAssertNil(calls[0].arguments.1)
        XCTAssertNil(calls[0].arguments.2)

        XCTAssertEqual(calls[1].arguments.0, notification)
        XCTAssertTrue(value(calls[1].arguments.1, is: obj))
        XCTAssertNil(calls[1].arguments.2)

        XCTAssertEqual(calls[2].arguments.0, notification)
        XCTAssertTrue(value(calls[1].arguments.1, is: obj))
        XCTAssertNil(calls[2].arguments.2)

        XCTAssertEqual(calls[3].arguments.0, notification)
        XCTAssertTrue(value(calls[1].arguments.1, is: obj))
        XCTAssertEqual(calls[3].arguments.2?["key"] as? String, "value")
    }

    func testCanMockRemovingObserver() {
        let observer = TestClass()
        center.removeObserver(observer)
        center.removeObserver(observer, name: notification, object: obj)

        let calls = center.calls(to: center.removeObserverRef)

        XCTAssertEqual(calls.count, 2)

        XCTAssertTrue(value(calls[0].arguments.0, is: observer))
        XCTAssertNil(calls[0].arguments.1)
        XCTAssertNil(calls[0].arguments.2)

        XCTAssertTrue(value(calls[1].arguments.0, is: observer))
        XCTAssertEqual(calls[1].arguments.1, notification)
        XCTAssertTrue(value(calls[1].arguments.2, is: obj))
    }
}

private class TestClass: NSObject {

    let id = UUID()

    @objc func testFunc() {}
}
