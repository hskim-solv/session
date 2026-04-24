import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var focusMinutes: Int = 25
    @Published var shortBreakMinutes: Int = 5
    @Published var longBreakMinutes: Int = 15
    @Published var savedMessage: String?

    private let store: SettingsStore
    var onSaved: ((PomodoroSettings) -> Void)?

    init(store: SettingsStore) {
        self.store = store
        apply(store.load())
    }

    func save() {
        let settings = PomodoroSettings(
            focusMinutes: max(1, focusMinutes),
            shortBreakMinutes: max(1, shortBreakMinutes),
            longBreakMinutes: max(1, longBreakMinutes)
        )
        store.save(settings)
        onSaved?(settings)
        savedMessage = "설정이 저장되었어요."
    }

    private func apply(_ settings: PomodoroSettings) {
        focusMinutes = settings.focusMinutes
        shortBreakMinutes = settings.shortBreakMinutes
        longBreakMinutes = settings.longBreakMinutes
    }
}
