import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // keep app running when window is closed
    }
}

@main
struct PomorinApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
