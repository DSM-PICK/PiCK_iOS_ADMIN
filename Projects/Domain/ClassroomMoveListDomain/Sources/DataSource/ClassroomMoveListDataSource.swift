import ClassroomMoveListDomainInterface

public protocol ClassroomMoveListDataSource {
    func getClassroomMoveByFloor(floor: Int) async throws -> [ClassroomMoveListResponseDTO]
    func getClassroomMoveByClassroom(grade: Int, classNum: Int) async throws ->
    [ClassroomMoveListResponseDTO]
}
