import SwiftUI

struct AboutView: View {
    private let appVersion =
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        ?? "1.0"
    private let buildNumber =
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            VStack(spacing: 16) {
                Image("logo")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .cornerRadius(16)

                VStack(spacing: 8) {
                    Text("Pomorin")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Pomodoro Timer for macOS")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                }
            }

            VStack(spacing: 8) {
                Text("Version \(appVersion) (Build \(buildNumber))")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("© 2025 Florin Stroe")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .frame(width: 400, height: 600)
        .padding(.horizontal, 30)
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("About Pomorin")
    }
}

#Preview {
    AboutView()
}
