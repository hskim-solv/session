import Foundation

protocol SettingsStore {
    func load() -> PomodoroSettings
    func save(_ settings: PomodoroSettings)
}
