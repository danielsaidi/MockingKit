//
//  MockTextDocumentProxy.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-07-04.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import UIKit

/**
 This class can be used as a mocked `UITextDocumentProxy`.

 This class mocks many functions, but not all. If you miss a
 certain function, you can subclass this class and mock more
 functionality in the subclass.
 */
open class MockTextDocumentProxy: NSObject, UITextDocumentProxy, Mockable {
    
    public lazy var adjustTextPositionRef = MockReference(adjustTextPosition)
    public lazy var deleteBackwardRef = MockReference(deleteBackward as () -> Void)
    public lazy var insertTextRef = MockReference(insertText)
    public lazy var setMarkedTextRef = MockReference(setMarkedText)
    public lazy var unmarkTextRef = MockReference(unmarkText)
    
    public let mock = Mock()
    
    public var hasText: Bool = false
    
    public var autocapitalizationType: UITextAutocapitalizationType = .none
    public var documentContextBeforeInput: String?
    public var documentContextAfterInput: String?
    public var documentIdentifier: UUID = UUID()
    public var documentInputMode: UITextInputMode?
    public var keyboardAppearance: UIKeyboardAppearance = .light
    public var selectedText: String?
    
    public func adjustTextPosition(byCharacterOffset offset: Int) {
        call(adjustTextPositionRef, args: (offset))
    }
    
    public func deleteBackward() {
        call(deleteBackwardRef, args: ())
    }
    
    public func insertText(_ text: String) {
        call(insertTextRef, args: (text))
    }
    
    public func setMarkedText(_ markedText: String, selectedRange: NSRange) {
        call(setMarkedTextRef, args: (markedText, selectedRange))
    }
    
    public func unmarkText() {
        call(unmarkTextRef, args: ())
    }
}
#else
import Foundation

/**
 This class can be used to mock a text document proxy.

 This mock doesn't do anything, since this platform does not
 have a text proxy. It's only here for documentation harmony.
 */
open class MockTextDocumentProxy: Mock {}
#endif

