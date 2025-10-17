//
//  DemoListText.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-11-27.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

struct DemoListText: View {
    
    init(_ text: String) {
        self.text = text
    }
    
    private let text: String
    
    var body: some View {
        Text(text)
            .lineSpacing(8)
            .padding(.vertical, 13)
    }
}

struct DemoListText_Previews: PreviewProvider {
    static var previews: some View {
        DemoListText("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    }
}
