//
//  MockScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-12-07.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This screen demonstrates how to trigger a mock and make use
 of the resulting call information.
 */
struct MockScreen: View {
    
    init(mock: TestMock = TestMock()) {
        self.mock = mock
    }
    
    private let mock: TestMock
    
    private let matchCount = 5
    
    @State private var hasCalled = false
    @State private var hasCalledCount = 0
    @State private var hasCalledMatch = false
    @State private var hasCalledWithArgs = false
    @State private var hasCalledWithArgsCount = 0
    @State private var hasCalledWithArgsMatch = false
    @State private var hasCalledWithArgsName = ""
    @State private var hasCalledWithArgsAge = 0
    
    var body: some View {
        DemoList("Mock") {
            Section(header: Text("About")) {
                DemoListText("This demo uses a TestMock to show how you can trigger funcs and inspect the resulting calls.")
            }
            
            Section(header: Text("Actions")) {
                DemoListButton("Trigger doStuff", doStuff)
                DemoListButton("Trigger doStuffWithArg w. random args", doStuffWithArgs)
            }
            
            Section(header: Text("Result: doStuff")) {
                DemoListText("Has called? \(hasCalled ? "Yes" : "No")")
                DemoListText("Has called \(hasCalledCount) times")
                DemoListText("Has called \(matchCount) times? \(hasCalledMatch ? "Yes" : "No")")
            }
            
            Section(header: Text("Result: doStuffWithArguments")) {
                DemoListText("Has called: \(hasCalledWithArgs ? "Yes" : "No")")
                DemoListText("Has called \(hasCalledWithArgsCount) times")
                DemoListText("Has called \(matchCount) times? \(hasCalledWithArgsMatch ? "Yes" : "No")")
                if hasCalledWithArgs {
                    DemoListText("Last name arg: \(hasCalledWithArgsName)")
                    DemoListText("Last age arg: \(hasCalledWithArgsAge)")
                }
            }
        }
    }
}

private extension MockScreen {
    
    func doStuff() {
        mock.doStuff()
        hasCalled = mock.hasCalled(mock.doStuffRef)
        hasCalledCount = mock.calls(to: mock.doStuffRef).count
        hasCalledMatch = mock.hasCalled(mock.doStuffRef, numberOfTimes: matchCount)
    }
    
    func doStuffWithArgs() {
        let name = "Member #\(Int.random(in: 1_000...9_999))"
        let age = Int.random(in: 18...100)
        mock.doStuffWithArgs(name: name, age: age)
        let calls = mock.callsokations(of: mock.doStuffWithArgsRef)
        hasCalledWithArgs = mock.hasCalled(mock.doStuffWithArgsRef)
        hasCalledWithArgsCount = calls.count
        hasCalledWithArgsMatch = mock.hasCalled(mock.doStuffWithArgsRef, numberOfTimes: matchCount)
        hasCalledWithArgsName = calls.last?.arguments.0 ?? ""
        hasCalledWithArgsAge = calls.last?.arguments.1 ?? -1
    }
}

struct MockScreen_Previews: PreviewProvider {
    static var previews: some View {
        MockScreen()
    }
}
