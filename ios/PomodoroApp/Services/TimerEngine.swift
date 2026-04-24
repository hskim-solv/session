import Foundation
import Combine

final class TimerEngine: ObservableObject {
    enum State {
        case idle
        case running
        case paused
        case finished
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var remainingSeconds: Int = 0

    private var totalSeconds: Int = 0
    private var ticker: AnyCancellable?
    private var startedAt: Date?

    func configure(minutes: Int) {
        totalSeconds = max(0, minutes * 60)
        remainingSeconds = totalSeconds
        startedAt = nil
        ticker?.cancel()
        state = .idle
    }

    func start() {
        guard state == .idle || state == .paused else { return }
        if startedAt == nil {
            startedAt = Date()
        }
        state = .running
        ticker?.cancel()
        ticker = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                guard self.remainingSeconds > 0 else {
                    self.finish()
                    return
                }
                self.remainingSeconds -= 1
                if self.remainingSeconds == 0 {
                    self.finish()
                }
            }
    }

    func pause() {
        guard state == .running else { return }
        state = .paused
        ticker?.cancel()
    }

    func stop() {
        ticker?.cancel()
        startedAt = nil
        state = .idle
    }

    func actualMinutes() -> Int {
        max(0, (totalSeconds - remainingSeconds) / 60)
    }

    func startTime() -> Date? {
        startedAt
    }

    private func finish() {
        ticker?.cancel()
        state = .finished
    }
}
