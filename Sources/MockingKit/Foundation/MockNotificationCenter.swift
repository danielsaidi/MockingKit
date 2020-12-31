//
//  MockNotificationCenter.swift
//  Mockery
//
//  Created by Daniel Saidi on 2020-08-03.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation

open class MockNotificationCenter: NotificationCenter, Mockable {
    
    public lazy var addObserverForNameRef = MockReference(mockAddObserverForName)
    public lazy var addObserverWithSelectorRef = MockReference(mockAddObserverWithSelector)
    public lazy var postNotificationRef = MockReference(mockPostNotification)
    public lazy var postNotificationNameRef = MockReference(mockPostNotificationName)
    public lazy var removeObserverRef = MockReference(mockRemoveObserver)
    
    public let mock = Mock()
    
    open override func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        mockAddObserverWithSelector(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    open override func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        mockAddObserverForName(name, object: obj, queue: queue, using: block)
    }
    
    open override func post(_ notification: Notification) {
        mockPostNotification(notification)
    }
    
    open override func post(name aName: NSNotification.Name, object anObject: Any?) {
        mockPostNotificationName(name: aName, object: anObject, userInfo: nil)
    }
    
    open override func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]? = nil) {
        mockPostNotificationName(name: aName, object: anObject, userInfo: aUserInfo)
    }
    
    open override func removeObserver(_ observer: Any) {
        mockRemoveObserver(observer, name: nil, object: nil)
    }
    
    open override func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) {
        mockRemoveObserver(observer, name: aName, object: anObject)
    }
}

/**
 These functions provide more explicit names, which makes it
 easier to create the refs without having to use typealiases.
 */
private extension MockNotificationCenter {
    
    func mockAddObserverForName(_ name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        invoke(addObserverForNameRef, args: (name, obj, queue, block))
    }
    
    func mockAddObserverWithSelector(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        invoke(addObserverWithSelectorRef, args: (observer, aSelector, aName, anObject))
    }
    
    func mockPostNotification(_ notification: Notification) {
        invoke(postNotificationRef, args: (notification))
    }
    
    func mockPostNotificationName(name aName: NSNotification.Name, object: Any?, userInfo: [AnyHashable: Any]?) {
        invoke(postNotificationNameRef, args: (aName, object, userInfo))
    }
    
    func mockRemoveObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) {
        invoke(removeObserverRef, args: (observer, aName, anObject))
    }
}
