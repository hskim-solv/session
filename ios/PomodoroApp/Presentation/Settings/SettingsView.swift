import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("시간 설정 (분)") {
                    Stepper("집중: \(viewModel.focusMinutes)분", value: $viewModel.focusMinutes, in: 1...120)
                    Stepper("짧은 휴식: \(viewModel.shortBreakMinutes)분", value: $viewModel.shortBreakMinutes, in: 1...60)
                    Stepper("긴 휴식: \(viewModel.longBreakMinutes)분", value: $viewModel.longBreakMinutes, in: 1...60)
                }

                Section {
                    Button("저장") {
                        viewModel.save()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                if let savedMessage = viewModel.savedMessage {
                    Section {
                        Text(savedMessage)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("설정")
        }
    }
}
