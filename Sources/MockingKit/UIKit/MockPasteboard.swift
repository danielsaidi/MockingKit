//
//  MockPasteboard.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2019-05-28.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import UIKit

open class MockPasteboard: UIPasteboard, Mockable {
    
    public lazy var setDataRef = MockReference(setData)

    public let mock = Mock()
    
    open override func setData(_ data: Data, forPasteboardType pasteboardType: String) {
        invoke(setDataRef, args: (data, pasteboardType))
    }
}
#endif
