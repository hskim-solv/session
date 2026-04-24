import Foundation

protocol SessionRepository {
    func save(_ session: PomodoroSession) throws
    func fetch(from: Date, to: Date, type: SessionType?) throws -> [PomodoroSession]
    func delete(id: UUID) throws
}
