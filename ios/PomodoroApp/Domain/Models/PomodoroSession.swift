import Foundation

struct PomodoroSession: Identifiable, Codable {
    let id: UUID
    let type: SessionType
    let startAt: Date
    let endAt: Date
    let plannedMinutes: Int
    let actualMinutes: Int
    let isCompleted: Bool
    var note: String?
}
