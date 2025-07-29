import AppKit
import SwiftUI

class StatusBarManager: ObservableObject {
    private var statusBarItem: NSStatusItem?
    weak private var pomodoroViewModel: PomodoroViewModel?
    private var openWindow: OpenWindowAction?
    
    init() {
        setupStatusBar()
    }
    
    private func setupStatusBar() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.title = "Pomorin" // Default title
            button.action = #selector(statusBarItemClicked)
            button.target = self
        }
    }
    
    func setPomodoroViewModel(_ viewModel: PomodoroViewModel) {
        self.pomodoroViewModel = viewModel
        updateStatusBarTitle()
    }
    
    func setOpenWindow(_ openWindow: OpenWindowAction) {
        self.openWindow = openWindow
    }
    
    func updateStatusBarTitle() {
        guard let viewModel = pomodoroViewModel else { return }
        
        DispatchQueue.main.async {
            if let button = self.statusBarItem?.button {
                let stateIcon = self.iconForState(viewModel.currentState)
                button.title = "\(stateIcon) \(viewModel.formattedTime)"
            }
        }
    }
    
    private func iconForState(_ state: TimerState) -> String {
        switch state {
        case .work:
            return "🍅"
        case .shortBreak:
            return "☕️"
        case .longBreak:
            return "🛋️"
        }
    }
    
    @objc private func statusBarItemClicked() {
        // Open the PomodoroWindow using the openWindow function
        openWindow?(id: "PomorinWindow")
        
        // Bring the app to front
        NSApp.activate(ignoringOtherApps: true)
    }
    
    deinit {
        if let statusBarItem = statusBarItem {
            NSStatusBar.system.removeStatusItem(statusBarItem)
        }
    }
}
