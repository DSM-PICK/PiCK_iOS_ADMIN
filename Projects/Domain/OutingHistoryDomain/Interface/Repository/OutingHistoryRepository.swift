import Foundation

public protocol OutingHistoryRepository {
    func getOutingHistory() async throws -> [OutingHistoryEntity]
}
