//
//  AboutScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-12-07.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

struct AboutScreen: View {
    
    var body: some View {
        DemoList("About MockingKit") {
            DemoListText(
                """
MockingKit is a Swift mocking library that makes it easy to mock protocol implementations for unit tests and not yet implemented functionality.

MockingKit basically consists of two things: the Mock base class and the Mockable protocol.

Use Mock when your mock doesn't have to inherit another class (most cases).

Use Mockable when your mock has to inherit another class (e.g. a mock NotificationCenter).

The only difference between Mock and Mockable is that a Mockable must have a "mock" property. Mock is just a Mockable that uses itself as "mock".

To create a mock implementation of a protocol, create a class that either inherits Mock or implements Mockable, then create references to the functions you want to mock. You can then invoke the functions references to "record" all function calls.
"""
            )
        }
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
}
