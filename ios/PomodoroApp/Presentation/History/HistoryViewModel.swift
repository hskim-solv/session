import Foundation
import Combine

final class HistoryViewModel: ObservableObject {
    enum Period: String, CaseIterable, Identifiable {
        case today = "오늘"
        case last7Days = "7일"
        case last30Days = "30일"

        var id: String { rawValue }
    }

    @Published var sessions: [PomodoroSession] = []
    @Published var totalFocusMinutesToday: Int = 0
    @Published var completedFocusCountToday: Int = 0
    @Published var completionRateText: String = "0%"
    @Published var selectedPeriod: Period = .today
    @Published var errorMessage: String?

    private let repository: SessionRepository

    init(repository: SessionRepository) {
        self.repository = repository
    }

    func loadToday() {
        selectedPeriod = .today
        load()
    }

    func load() {
        let calendar = Calendar.current
        let now = Date()
        let start: Date
        switch selectedPeriod {
        case .today:
            start = calendar.startOfDay(for: now)
        case .last7Days:
            start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) ?? now
        case .last30Days:
            start = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: now)) ?? now
        }
        let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) ?? now

        do {
            let all = try repository.fetch(from: start, to: end, type: nil)
            sessions = all.sorted { $0.startAt > $1.startAt }

            let focus = all.filter { $0.type == .focus }
            totalFocusMinutesToday = focus.map(\.actualMinutes).reduce(0, +)
            completedFocusCountToday = focus.filter(\.isCompleted).count
            if focus.isEmpty {
                completionRateText = "0%"
            } else {
                let rate = Int((Double(completedFocusCountToday) / Double(focus.count)) * 100)
                completionRateText = "\(rate)%"
            }
            errorMessage = nil
        } catch {
            sessions = []
            totalFocusMinutesToday = 0
            completedFocusCountToday = 0
            completionRateText = "0%"
            errorMessage = "기록을 불러오지 못했어요."
        }
    }

    func deleteSessions(at offsets: IndexSet) {
        let targets = offsets.compactMap { index in
            sessions.indices.contains(index) ? sessions[index] : nil
        }

        do {
            for target in targets {
                try repository.delete(id: target.id)
            }
            load()
        } catch {
            errorMessage = "기록 삭제에 실패했어요."
        }
    }
}
