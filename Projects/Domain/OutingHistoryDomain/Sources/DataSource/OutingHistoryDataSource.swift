import OutingHistoryDomainInterface

public protocol OutingHistoryDataSource {
    func getOutingHistory() async throws -> [OutingHistoryResponseDTO]
}
