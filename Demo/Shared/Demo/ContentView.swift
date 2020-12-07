//
//  ContentView.swift
//  Shared
//
//  Created by Daniel Saidi on 2020-12-07.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            DemoList("Mockery") {
                Section(header: Text("About")) {
                    DemoListLink("About Mockery", .about, AboutScreen())   
                }
                
                Section(header: Text("Mocks")) {
                    DemoListLink("Mock", .circleDashedFilled, MockScreen())
                    DemoListLink("Mockable", .circleDashed, MockableScreen())
                }
            }
        }.withPlatformSpecificNavigationStyle()
    }
}

private extension View {
    
    func withPlatformSpecificNavigationStyle() -> some View {
        #if os(iOS)
        return self.navigationViewStyle(StackNavigationViewStyle())
        #else
        return self
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
