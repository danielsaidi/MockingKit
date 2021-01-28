//
//  MockTextDocumentProxy.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-07-04.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import UIKit

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
    public var selectedText: String?
    public var documentInputMode: UITextInputMode?
    public var documentIdentifier: UUID = UUID()
    
    public func adjustTextPosition(byCharacterOffset offset: Int) {
        invoke(adjustTextPositionRef, args: (offset))
    }
    
    public func deleteBackward() {
        documentContextBeforeInput?.removeLast()
        invoke(deleteBackwardRef, args: ())
    }
    
    public func insertText(_ text: String) {
        invoke(insertTextRef, args: (text))
    }
    
    public func setMarkedText(_ markedText: String, selectedRange: NSRange) {
        invoke(setMarkedTextRef, args: (markedText, selectedRange))
    }
    
    public func unmarkText() {
        invoke(unmarkTextRef, args: ())
    }
}
#endif
