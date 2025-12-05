import OutListDomainInterface

public protocol OutListDataSource {
    func getOutList(floor: Int) async throws -> [OutListResponseDTO]
    func returnStudents(ids: [String]) async throws
}
