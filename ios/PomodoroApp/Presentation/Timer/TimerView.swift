import SwiftUI

struct TimerView: View {
    @StateObject var viewModel: TimerViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text(title(for: viewModel.currentType))
                .font(.title.bold())

            Text(timeString(viewModel.engine.remainingSeconds))
                .font(.system(size: 56, weight: .bold, design: .rounded))

            HStack(spacing: 12) {
                Button("시작") { viewModel.start() }
                Button("일시정지") { viewModel.pause() }
                Button("중지") { viewModel.stopEarly() }
            }
            .buttonStyle(.borderedProminent)

            Text("연속 집중: \(viewModel.focusStreak)회")
                .foregroundStyle(.secondary)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
        .padding()
    }

    private func title(for type: SessionType) -> String {
        switch type {
        case .focus:
            return "집중"
        case .shortBreak:
            return "짧은 휴식"
        case .longBreak:
            return "긴 휴식"
        }
    }

    private func timeString(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
