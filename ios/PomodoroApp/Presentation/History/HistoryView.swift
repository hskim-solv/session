import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel: HistoryViewModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("기간", selection: $viewModel.selectedPeriod) {
                        ForEach(HistoryViewModel.Period.allCases) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: viewModel.selectedPeriod) { _ in
                        viewModel.load()
                    }
                }

                Section("오늘 통계") {
                    HStack {
                        Text("집중 시간")
                        Spacer()
                        Text("\(viewModel.totalFocusMinutesToday)분")
                    }
                    HStack {
                        Text("완료 세션")
                        Spacer()
                        Text("\(viewModel.completedFocusCountToday)회")
                    }
                }

                Section("세션 기록") {
                    if viewModel.sessions.isEmpty {
                        Text("해당 기간에 기록이 없어요.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(viewModel.sessions) { session in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(label(for: session.type))
                                .font(.headline)
                            Text("실제 \(session.actualMinutes)분 / 계획 \(session.plannedMinutes)분")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("기록")
            .onAppear {
                viewModel.loadToday()
            }
        }
    }

    private func label(for type: SessionType) -> String {
        switch type {
        case .focus:
            return "집중"
        case .shortBreak:
            return "짧은 휴식"
        case .longBreak:
            return "긴 휴식"
        }
    }
}
