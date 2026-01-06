//
//  Image+Demo.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-11-26.
//  Copyright © 2020-2026 Daniel Saidi. All rights reserved.
//

import SwiftUI

extension Image {
    
    static let about = symbol("questionmark")
    static let circle = symbol("circle")
    static let circleDashed = symbol("circle.dashed")
    static let circleDashedFilled = symbol("circle.dashed.inset.fill")

    static func symbol(_ name: String) -> Image {
        .init(systemName: name)
    }
}
