import SwiftUI
import AVFoundation

struct PomodoroTimerView: View {
    @EnvironmentObject private var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Timer State
            Text(pomodoroViewModel.stateDescription)
                .font(.title2)
                .foregroundColor(colorForState(pomodoroViewModel.currentState))
                .fontWeight(.semibold)
            
            // Circular Progress View
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: pomodoroViewModel.progress)
                    .stroke(colorForState(pomodoroViewModel.currentState), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: pomodoroViewModel.progress)
                
                VStack {
                    Text(pomodoroViewModel.formattedTime)
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                    
                    Text("remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Pomodoros Completed
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Completed pomodori today: \(pomodoroViewModel.completedPomodoros)")
                    .font(.headline)
            }
            .padding(.horizontal)
            
            // Control Buttons
            HStack(spacing: 20) {
                Button(action: {
                    if pomodoroViewModel.isRunning {
                        pomodoroViewModel.pauseTimer()
                    } else {
                        pomodoroViewModel.startTimer()
                    }
                }) {
                    HStack {
                        Image(systemName: pomodoroViewModel.isRunning ? "pause.fill" : "play.fill")
                        Text(pomodoroViewModel.isRunning ? "Pause" : "Start")
                    }
                    .frame(width: 100, height: 40)
                    .background(colorForState(pomodoroViewModel.currentState))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    pomodoroViewModel.resetTimer()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Reset")
                    }
                    .frame(width: 100, height: 40)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    pomodoroViewModel.skipToNext()
                }) {
                    HStack {
                        Image(systemName: "forward.end")
                        Text("Skip")
                    }
                    .frame(width: 100, height: 40)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            VStack(alignment: .leading) {
                // toggle skip breaks
                Toggle("Skip Breaks", isOn: $pomodoroViewModel.skipBreaks)
                    .padding(.horizontal)
                    .font(.headline)
                
                // toggle auto start
                Toggle("Auto Start", isOn: $pomodoroViewModel.autoStart)
                    .padding(.horizontal)
                    .font(.headline)
            }
            Spacer()
            
            Text("Made with ❤️ by Florin Stroe")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
        }
        .onChange(of: pomodoroViewModel.pomodoroMinutes) {
            pomodoroViewModel.resetTimer()
        }
        .onChange(of: pomodoroViewModel.shortBreakMinutes) {
            pomodoroViewModel.resetTimer()
        }
        .onChange(of: pomodoroViewModel.longBreakMinutes) {
            pomodoroViewModel.resetTimer()
        }
    }
    
    private func colorForState(_ state: TimerState) -> Color {
        switch state {
        case .work:
            return .red
        case .shortBreak:
            return .green
        case .longBreak:
            return .blue
        }
    }
}

#Preview {
    PomodoroTimerView()
        .environmentObject(PomodoroViewModel())
}
