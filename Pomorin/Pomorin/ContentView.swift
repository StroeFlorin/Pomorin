//
//  ContentView.swift
//  Pomorin
//
//  Created by Florin Stroe on 28.07.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            PomodoroTimerView()
                .toolbar {
                    ToolbarItem {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .navigationTitle("Pomorin - Pomodoro Timer for MacOS")
        }
    }
}

#Preview {
    ContentView()
}
