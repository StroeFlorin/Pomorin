//
//  PomorinApp.swift
//  Pomorin
//
//  Created by Florin Stroe on 28.07.2025.
//

import AppKit
import SwiftUI

@main
struct PomorinApp: App {
    @StateObject private var pomodoroViewModel = PomodoroViewModel()
    @StateObject private var statusBarManager = StatusBarManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroViewModel)
                .onAppear {
                    pomodoroViewModel.setStatusBarManager(statusBarManager)
                }
        }
    }
}
