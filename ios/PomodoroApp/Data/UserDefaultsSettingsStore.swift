import Foundation

final class UserDefaultsSettingsStore: SettingsStore {
    private let key = "pomodoro.settings.v1"
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> PomodoroSettings {
        guard let data = defaults.data(forKey: key),
              let settings = try? decoder.decode(PomodoroSettings.self, from: data) else {
            return .default
        }
        return settings
    }

    func save(_ settings: PomodoroSettings) {
        guard let encoded = try? encoder.encode(settings) else { return }
        defaults.set(encoded, forKey: key)
    }
}
