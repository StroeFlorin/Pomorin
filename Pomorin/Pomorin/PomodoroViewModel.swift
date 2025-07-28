import AVFoundation
import SwiftUI

enum TimerState {
    case work
    case shortBreak
    case longBreak
    case stopped
}

class PomodoroViewModel: ObservableObject {
    @Published var timeRemaining: Int = 0
    @Published var isRunning: Bool = false
    @Published var currentState: TimerState = .work
    @Published var completedPomodoros: Int = 0

    private var timer: Timer?

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

    init() {
        resetTimer()
    }

    func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            _ in
            DispatchQueue.main.async {
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timerCompleted()
                }
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
        case .stopped:
            timeRemaining = pomodoroMinutes * 60
            currentState = .work
        }
    }

    private func timerCompleted() {
        pauseTimer()

        if sendNotification {
            // notification logic here
        }

        switch currentState {
        case .work:
            completedPomodoros += 1
            if completedPomodoros % longBreakInterval == 0 {
                currentState = .longBreak
            } else {
                currentState = .shortBreak
            }
        case .shortBreak, .longBreak:
            currentState = .work
        case .stopped:
            break
        }

        resetTimer()
    }

    func skipToNext() {
        timerCompleted()
    }

    var progress: Double {
        let totalTime: Int
        switch currentState {
        case .work:
            totalTime = pomodoroMinutes * 60
        case .shortBreak:
            totalTime = shortBreakMinutes * 60
        case .longBreak:
            totalTime = longBreakMinutes * 60
        case .stopped:
            totalTime = pomodoroMinutes * 60
        }
        return totalTime > 0 ? Double(totalTime - timeRemaining) / Double(totalTime) : 0
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
        case .stopped:
            return "Ready to Start"
        }
    }
}
