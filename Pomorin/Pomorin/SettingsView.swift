import AppKit
import SwiftUI

struct SettingsView: View {
    @AppStorage("pomodoroMinutes") private var pomodoroMinutes: Int = 25
    @AppStorage("shortBreakMinutes") private var shortBreakMinutes: Int = 5
    @AppStorage("longBreakMinutes") private var longBreakMinutes: Int = 15
    @AppStorage("longBreakInterval") private var longBreakInterval: Int = 4
    @AppStorage("sendNotification") private var sendNotification: Bool = true

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Stepper {
                    Text("Pomodoro time: \(pomodoroMinutes) minutes")
                        .font(.title3)
                } onIncrement: {
                    pomodoroMinutes += 1
                } onDecrement: {
                    guard pomodoroMinutes > 1 else { return }
                    pomodoroMinutes -= 1
                }
                .tint(.accentColor)

                Stepper {
                    Text("Short break time: \(shortBreakMinutes) minutes")
                        .font(.title3)
                } onIncrement: {
                    shortBreakMinutes += 1
                } onDecrement: {
                    guard shortBreakMinutes > 1 else { return }
                    shortBreakMinutes -= 1
                }
                .tint(.accentColor)

                Stepper {
                    Text("Long break time: \(longBreakMinutes) minutes")
                        .font(.title3)
                } onIncrement: {
                    longBreakMinutes += 1
                } onDecrement: {
                    guard longBreakMinutes > 1 else { return }
                    longBreakMinutes -= 1
                }
                .tint(.accentColor)

                Stepper {
                    Text("Long break every \(longBreakInterval) pomodori")
                        .font(.title3)
                } onIncrement: {
                    longBreakInterval += 1
                } onDecrement: {
                    guard longBreakInterval > 1 else { return }
                    longBreakInterval -= 1
                }
                .tint(.accentColor)

                Toggle("Notify me when the timer ends", isOn: $sendNotification)
                    .font(.title3)

            }
            .padding(30)
            .background(
                .regularMaterial,
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12).stroke(
                    Color(NSColor.separatorColor),
                    lineWidth: 1
                )
            )
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Settings")

    }
}

#Preview {
    SettingsView()
}
