//
//  PomorinApp.swift
//  Pomorin
//
//  Created by Florin Stroe on 28.07.2025.
//

import SwiftUI

@main
struct PomorinApp: App {
    @StateObject private var pomodoroViewModel = PomodoroViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroViewModel)
        }
    }
}
