import AppKit
import SwiftUI

struct SettingsView: View {
    @AppStorage("pomodoroMinutes") private var pomodoroMinutes: Int = 25
    @AppStorage("shortBreakMinutes") private var shortBreakMinutes: Int = 5
    @AppStorage("longBreakMinutes") private var longBreakMinutes: Int = 15
    @AppStorage("longBreakInterval") private var longBreakInterval: Int = 4
    @AppStorage("sendNotification") private var sendNotification: Bool = true
    
    private let timerColor = Color.blue
    private let breakColor = Color.green

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 8) {
                    Image(systemName: "gear")
                        .font(.system(size: 40))
                        .foregroundColor(.accentColor)
                    Text("Timer Settings")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Customize your Pomodoro experience")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Timer Durations Section
                SettingsSectionView(
                    title: "Timer Durations",
                    icon: "clock.fill",
                    iconColor: timerColor
                ) {
                    VStack(spacing: 16) {
                        CustomStepperView(
                            label: "Pomodoro",
                            value: $pomodoroMinutes,
                            unit: "minutes",
                            color: timerColor,
                            icon: "timer"
                        )
                        
                        Divider()
                        
                        CustomStepperView(
                            label: "Short Break",
                            value: $shortBreakMinutes,
                            unit: "minutes",
                            color: breakColor,
                            icon: "cup.and.saucer.fill"
                        )
                        
                        Divider()
                        
                        CustomStepperView(
                            label: "Long Break",
                            value: $longBreakMinutes,
                            unit: "minutes",
                            color: breakColor,
                            icon: "fork.knife"
                        )
                    }
                }
                
                // Session Settings Section
                SettingsSectionView(
                    title: "Session Settings",
                    icon: "repeat.circle.fill",
                    iconColor: .orange
                ) {
                    VStack(spacing: 16) {
                        CustomStepperView(
                            label: "Long Break Interval",
                            value: $longBreakInterval,
                            unit: "pomodori",
                            color: .orange,
                            icon: "arrow.triangle.2.circlepath"
                        )
                    }
                }
                
                // Notifications Section
                SettingsSectionView(
                    title: "Notifications",
                    icon: "bell.fill",
                    iconColor: .purple
                ) {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .font(.title3)
                                .foregroundColor(.purple)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Timer Notifications")
                                    .font(.headline)
                                Text("Get notified when timer sessions end")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $sendNotification)
                                .toggleStyle(SwitchToggleStyle())
                        }
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Settings")
    }
}

// MARK: - Custom Components

struct SettingsSectionView<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 0) {
                content
                    .padding(20)
            }
            .background(
                .regularMaterial,
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(NSColor.separatorColor).opacity(0.5), lineWidth: 1)
            )
        }
    }
}

struct CustomStepperView: View {
    let label: String
    @Binding var value: Int
    let unit: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon and label
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.headline)
                    Text("\(value) \(unit)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Custom stepper buttons
            HStack(spacing: 8) {
                Button(action: {
                    guard value > 1 else { return }
                    value -= 1
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(value > 1 ? color : Color.gray)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(value <= 1)
                
                Text("\(value)")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .frame(minWidth: 40)
                
                Button(action: {
                    value += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(color)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
