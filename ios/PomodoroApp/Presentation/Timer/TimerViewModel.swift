import Foundation
import Combine

final class TimerViewModel: ObservableObject {
    @Published var currentType: SessionType = .focus
    @Published var focusStreak: Int = 0
    @Published var errorMessage: String?

    let engine: TimerEngine
    private let repository: SessionRepository
    private var cancellables = Set<AnyCancellable>()

    var focusMinutes = 25
    var shortBreakMinutes = 5
    var longBreakMinutes = 15
    var onSessionSaved: (() -> Void)?

    init(engine: TimerEngine, repository: SessionRepository) {
        self.engine = engine
        self.repository = repository

        engine.$state
            .sink { [weak self] state in
                guard let self else { return }
                if state == .finished {
                    self.completeSession(isCompleted: true)
                    self.moveToNextType()
                }
            }
            .store(in: &cancellables)

        configureByType()
    }

    func start() {
        engine.start()
    }

    func pause() {
        engine.pause()
    }

    func stopEarly() {
        completeSession(isCompleted: false)
        engine.stop()
        configureByType()
    }

    func apply(settings: PomodoroSettings) {
        focusMinutes = settings.focusMinutes
        shortBreakMinutes = settings.shortBreakMinutes
        longBreakMinutes = settings.longBreakMinutes
        configureByType()
    }

    private func configureByType() {
        let minutes: Int
        switch currentType {
        case .focus:
            minutes = focusMinutes
        case .shortBreak:
            minutes = shortBreakMinutes
        case .longBreak:
            minutes = longBreakMinutes
        }
        engine.configure(minutes: minutes)
    }

    private func completeSession(isCompleted: Bool) {
        guard let start = engine.startTime() else { return }
        let planned = plannedMinutes(for: currentType)
        let end = Date()
        let session = PomodoroSession(
            id: UUID(),
            type: currentType,
            startAt: start,
            endAt: end,
            plannedMinutes: planned,
            actualMinutes: engine.actualMinutes(),
            isCompleted: isCompleted,
            note: nil
        )
        do {
            try repository.save(session)
            onSessionSaved?()
            errorMessage = nil
        } catch {
            errorMessage = "세션 저장에 실패했어요. 다시 시도해주세요."
        }
    }

    private func moveToNextType() {
        if currentType == .focus {
            focusStreak += 1
            currentType = (focusStreak % 4 == 0) ? .longBreak : .shortBreak
        } else {
            currentType = .focus
        }
        configureByType()
    }

    private func plannedMinutes(for type: SessionType) -> Int {
        switch type {
        case .focus:
            return focusMinutes
        case .shortBreak:
            return shortBreakMinutes
        case .longBreak:
            return longBreakMinutes
        }
    }
}
