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
        statusBarItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.variableLength
        )

        let menu = NSMenu()

        let openItem = NSMenuItem(
            title: "Open Pomorin",
            action: #selector(openWindowMenuItemClicked),
            keyEquivalent: ""
        )
        openItem.target = self
        menu.addItem(openItem)

        let aboutItem = NSMenuItem(
            title: "About",
            action: #selector(aboutMenuItemClicked),
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)

        let exitItem = NSMenuItem(
            title: "Exit",
            action: #selector(exitMenuItemClicked),
            keyEquivalent: ""
        )
        exitItem.target = self
        menu.addItem(exitItem)

        statusBarItem?.menu = menu

        if let button = statusBarItem?.button {
            button.title = "Pomorin"  // Default title
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

    deinit {
        if let statusBarItem = statusBarItem {
            NSStatusBar.system.removeStatusItem(statusBarItem)
        }
    }

    @objc private func openWindowMenuItemClicked() {
        openWindow?(id: "PomorinWindow")
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func aboutMenuItemClicked() {
        openWindow?(id: "AboutWindow")
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func exitMenuItemClicked() {
        NSApp.terminate(nil)
    }
}
