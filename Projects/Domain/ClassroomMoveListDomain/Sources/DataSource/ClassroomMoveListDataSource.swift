import ClassroomMoveListDomainInterface

public protocol ClassroomMoveListDataSource {
    func getClassroomMoveByFloor(floor: Int) async throws -> [ClassroomMoveListResponseDTO]
}
