import Foundation

final class InMemorySessionRepository: SessionRepository {
    private var storage: [PomodoroSession] = []

    func save(_ session: PomodoroSession) throws {
        storage.append(session)
    }

    func fetch(from: Date, to: Date, type: SessionType?) throws -> [PomodoroSession] {
        storage.filter { item in
            let inRange = (item.startAt >= from && item.startAt < to)
            let typeMatched = (type == nil || item.type == type)
            return inRange && typeMatched
        }
    }

    func delete(id: UUID) throws {
        storage.removeAll { $0.id == id }
    }
}
