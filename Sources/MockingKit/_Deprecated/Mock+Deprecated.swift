//
//  Mock+Deprecations.swift
//  MockingKit
//
//  Created by Daniel Saidi on 2021-02-03.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Foundation

public extension Mock {
    
    @available(*, deprecated, renamed: "registeredCalls")
    var registeredInvokations: [UUID: [AnyInvokation]] {
        get { registeredCalls }
        set { registeredCalls = newValue }
    }
}
