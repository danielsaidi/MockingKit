//
//  MockableScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-12-07.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

struct MockableScreen: View {
    
    init(mock: TestMockable = TestMockable()) {
        self.mock = mock
    }
    
    private let mock: TestMockable
    
    private let matchCount = 5
    
    @State private var hasInvoked = false
    @State private var hasInvokedCount = 0
    @State private var hasInvokedMatch = false
    @State private var hasInvokedWithArgs = false
    @State private var hasInvokedWithArgsCount = 0
    @State private var hasInvokedWithArgsMatch = false
    @State private var hasInvokedWithArgsName = ""
    @State private var hasInvokedWithArgsAge = 0
    
    var body: some View {
        DemoList("Mockable") {
            Section(header: Text("About")) {
                DemoListText("This demo uses a TestMockable to show how you can trigger funcs and inspect the resulting invokations.")
            }
            
            Section(header: Text("Actions")) {
                DemoListButton("Trigger doStuff", doStuff)
                DemoListButton("Trigger doStuffWithArg w. random args", doStuffWithArgs)
            }
            
            Section(header: Text("Result: doStuff")) {
                DemoListText("Has invoked? \(hasInvoked ? "Yes" : "No")")
                DemoListText("Has invoked \(hasInvokedCount) times")
                DemoListText("Has invoked \(matchCount) times? \(hasInvokedMatch ? "Yes" : "No")")
            }
            
            Section(header: Text("Result: doStuffWithArguments")) {
                DemoListText("Has invoked: \(hasInvokedWithArgs ? "Yes" : "No")")
                DemoListText("Has invoked \(hasInvokedWithArgsCount) times")
                DemoListText("Has invoked \(matchCount) times? \(hasInvokedWithArgsMatch ? "Yes" : "No")")
                if hasInvokedWithArgs {
                    DemoListText("Last name arg: \(hasInvokedWithArgsName)")
                    DemoListText("Last age arg: \(hasInvokedWithArgsAge)")
                }
            }
        }
    }
}

private extension MockableScreen {
    
    func doStuff() {
        mock.doStuff()
        hasInvoked = mock.hasInvoked(mock.doStuffRef)
        hasInvokedCount = mock.invokations(of: mock.doStuffRef).count
        hasInvokedMatch = mock.hasInvoked(mock.doStuffRef, numberOfTimes: matchCount)
    }
    
    func doStuffWithArgs() {
        let name = "Member #\(Int.random(in: 1_000...9_999))"
        let age = Int.random(in: 18...100)
        mock.doStuffWithArgs(name: name, age: age)
        let inv = mock.invokations(of: mock.doStuffWithArgsRef)
        hasInvokedWithArgs = mock.hasInvoked(mock.doStuffWithArgsRef)
        hasInvokedWithArgsCount = inv.count
        hasInvokedWithArgsMatch = mock.hasInvoked(mock.doStuffWithArgsRef, numberOfTimes: matchCount)
        hasInvokedWithArgsName = inv.last?.arguments.0 ?? ""
        hasInvokedWithArgsAge = inv.last?.arguments.1 ?? -1
    }
}

struct MockableScreen_Previews: PreviewProvider {
    static var previews: some View {
        MockableScreen()
    }
}
