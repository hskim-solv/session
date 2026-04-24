import Foundation

enum JSONFileSessionRepositoryError: Error {
    case failedToEncode
    case failedToDecode
}

final class JSONFileSessionRepository: SessionRepository {
    private let fileURL: URL
    private var storage: [PomodoroSession] = []
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(fileName: String = "pomodoro_sessions.json") {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        self.fileURL = directory.appendingPathComponent(fileName)
        self.storage = (try? loadFromDisk()) ?? []
    }

    func save(_ session: PomodoroSession) throws {
        storage.append(session)
        try persist()
    }

    func fetch(from: Date, to: Date, type: SessionType?) throws -> [PomodoroSession] {
        storage.filter { item in
            let inRange = item.startAt >= from && item.startAt < to
            let typeMatched = type == nil || item.type == type
            return inRange && typeMatched
        }
    }

    func delete(id: UUID) throws {
        storage.removeAll { $0.id == id }
        try persist()
    }

    private func persist() throws {
        guard let data = try? encoder.encode(storage) else {
            throw JSONFileSessionRepositoryError.failedToEncode
        }
        try data.write(to: fileURL, options: .atomic)
    }

    private func loadFromDisk() throws -> [PomodoroSession] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        guard let sessions = try? decoder.decode([PomodoroSession].self, from: data) else {
            throw JSONFileSessionRepositoryError.failedToDecode
        }
        return sessions
    }
}
