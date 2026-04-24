import Foundation

struct PomodoroSettings: Codable, Equatable {
    var focusMinutes: Int
    var shortBreakMinutes: Int
    var longBreakMinutes: Int

    static let `default` = PomodoroSettings(
        focusMinutes: 25,
        shortBreakMinutes: 5,
        longBreakMinutes: 15
    )
}
