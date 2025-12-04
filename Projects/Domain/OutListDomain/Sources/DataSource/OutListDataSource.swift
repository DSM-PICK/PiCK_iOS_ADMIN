import OutListDomainInterface

public protocol OutListDataSource {
    func getOutList(floor: Int) async throws -> [OutListResponseDTO]
}
