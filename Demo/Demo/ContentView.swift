//
//  ContentView.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-12-07.
//  Copyright © 2020-2026 Daniel Saidi. All rights reserved.
//

import MockingKit
import SwiftUI

struct ContentView: View {

    private let mock = TestMockable()
    private let matchCount = 5

    @State private var hasCalled = false
    @State private var hasCalledCount = 0
    @State private var hasCalledMatch = false
    @State private var hasCalledWithArgs = false
    @State private var hasCalledWithArgsCount = 0
    @State private var hasCalledWithArgsName = ""
    @State private var hasCalledWithArgsAge = 0

    var body: some View {
        NavigationStack {
            DemoList("Mockable") {
                Section("About") {
                    Text("This demo uses a test mock to show how to trigger funcs and inspect the resulting calls.")
                }

                Section("doStuff") {
                    listItem("Has been called?", "\(hasCalled ? "Yes" : "No")")
                    listItem("Call count", "\(hasCalledCount) times")
                    listItem("Has called \(matchCount) times?", "\(hasCalledMatch ? "Yes" : "No")")
                    Button(action: doStuff) {
                        Text("Trigger").frame(maxWidth: .infinity)
                    }
                }


                Section("doStuffWithArguments") {
                    listItem("Has been called?", "\(hasCalledWithArgs ? "Yes" : "No")")
                    listItem("Call Count", "\(hasCalledWithArgsCount) times")
                    if hasCalledWithArgs {
                        listItem("Last name:", "\(hasCalledWithArgsName)")
                        listItem("Last age:", "\(hasCalledWithArgsAge)")
                    }
                    Button(action: doStuffWithArgs) {
                        Text("Trigger").frame(maxWidth: .infinity)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

private extension ContentView {

    func listItem(_ title: String, _ text: String) -> some View {
        LabeledContent(title, value: text)
    }
}

private extension ContentView {

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
        let calls = mock.calls(to: mock.doStuffWithArgsRef)
        hasCalledWithArgs = mock.hasCalled(mock.doStuffWithArgsRef)
        hasCalledWithArgsCount = calls.count
        hasCalledWithArgsName = calls.last?.arguments.0 ?? ""
        hasCalledWithArgsAge = calls.last?.arguments.1 ?? -1
    }
}

#Preview {
    ContentView()
}
