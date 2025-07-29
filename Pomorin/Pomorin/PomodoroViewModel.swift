import AVFoundation
import SwiftUI
import UserNotifications

enum TimerState {
    case work
    case shortBreak
    case longBreak
}

class PomodoroViewModel: ObservableObject {
    @Published var timeRemaining: Int = 0
    @Published var isRunning: Bool = false
    @Published var currentState: TimerState = .work
    @Published var completedPomodoros: Int = 0
    
    @AppStorage("pomodoroMinutes") var pomodoroMinutes: Int = 25 {
        didSet { resetTimer() }
    }
    @AppStorage("shortBreakMinutes") var shortBreakMinutes: Int = 5 {
        didSet { resetTimer() }
    }
    @AppStorage("longBreakMinutes") var longBreakMinutes: Int = 15 {
        didSet { resetTimer() }
    }
    @AppStorage("longBreakInterval") var longBreakInterval: Int = 4
    @AppStorage("sendNotification") var sendNotification: Bool = true
    @AppStorage("skipBreaks") var skipBreaks: Bool = false
    @AppStorage("autoStart") var autoStart: Bool = false

    var statusBarManager: StatusBarManager?
    private var timer: Timer?
    
    init() {
        resetTimer()
        UNUserNotificationCenter.current().requestAuthorization(options: [
            .alert, .sound,
        ]) { granted, error in
            if let error = error {
                print(
                    "Notification permission error: \(error.localizedDescription)"
                )
            }
        }
    }
    
    func setStatusBarManager(_ manager: StatusBarManager) {
        self.statusBarManager = manager
        manager.setPomodoroViewModel(self)
    }

    func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.statusBarManager?.updateStatusBarTitle()
            } else {
                self.timerCompleted()
            }
        }
    }

    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        pauseTimer()
        switch currentState {
        case .work:
            timeRemaining = pomodoroMinutes * 60
        case .shortBreak:
            timeRemaining = shortBreakMinutes * 60
        case .longBreak:
            timeRemaining = longBreakMinutes * 60
        }
        statusBarManager?.updateStatusBarTitle()
    }

    private func timerCompleted() {
        pauseTimer()

        if sendNotification {
            sendTimerEndedNotification(for: currentState)
        }

        switch currentState {
        case .work:
            completedPomodoros += 1
            if skipBreaks {
                currentState = .work
            } else if completedPomodoros % longBreakInterval == 0 {
                currentState = .longBreak
            } else {
                currentState = .shortBreak
            }
        case .shortBreak, .longBreak:
            currentState = .work
        }

        resetTimer()
        if autoStart {
            startTimer()
        }
    }

    func skipToNext() {
        timerCompleted()
    }

    private func sendTimerEndedNotification(for state: TimerState) {
        let content = UNMutableNotificationContent()
        let endMessage: String
        switch state {
        case .work:
            endMessage = "Pomodoro timer ended!"
        case .shortBreak:
            endMessage = "Short break ended!"
        case .longBreak:
            endMessage = "Long break ended!"
        }
        content.title = "Pomorin"
        content.body = endMessage
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(
            request,
            withCompletionHandler: nil
        )
    }

    // progress for the circle progress view
    var progress: Double {
        let totalTime: Int
        switch currentState {
        case .work:
            totalTime = pomodoroMinutes * 60
        case .shortBreak:
            totalTime = shortBreakMinutes * 60
        case .longBreak:
            totalTime = longBreakMinutes * 60
        }
        return totalTime > 0
            ? Double(totalTime - timeRemaining) / Double(totalTime) : 0
    }

    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var stateDescription: String {
        switch currentState {
        case .work:
            return "Work Time"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }
}
