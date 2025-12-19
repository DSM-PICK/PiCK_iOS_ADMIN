import OutListDomainInterface

public protocol OutListDataSource {
    func getOutList(floor: Int) async throws -> [OutListResponseDTO]
    func returnStudents(ids: [String]) async throws
    func getEarlyReturn(floor: Int, status: String) async throws -> [EarlyReturnResponseDTO]
}
