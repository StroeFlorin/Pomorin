import AppKit
import SwiftUI

class StatusBarManager: ObservableObject {
    private var statusBarItem: NSStatusItem?
    weak private var pomodoroViewModel: PomodoroViewModel?
    
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
        // Bring the main window to front when status bar item is clicked
        NSApp.activate(ignoringOtherApps: true)
        
        // Find and bring the main window to front
        if let mainWindow = NSApp.windows.first(where: { $0.isMainWindow || $0.isKeyWindow }) {
            mainWindow.makeKeyAndOrderFront(nil)
        } else if let firstWindow = NSApp.windows.first {
            firstWindow.makeKeyAndOrderFront(nil)
        }
    }
    
    deinit {
        if let statusBarItem = statusBarItem {
            NSStatusBar.system.removeStatusItem(statusBarItem)
        }
    }
}
