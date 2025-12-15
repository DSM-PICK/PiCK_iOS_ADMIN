import Foundation

public protocol GetOutingHistoryUseCase {
    func execute() async throws -> [OutingHistoryEntity]
}
