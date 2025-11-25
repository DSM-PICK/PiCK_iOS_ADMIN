import Foundation

public protocol AcceptDataSource {
    func getApplicationsByGrade(grade: Int, classNum: Int) async throws -> ApplicationListResponseDTO
    func getApplicationsByFloor(floor: Int) async throws -> ClassroomMoveListResponseDTO
    func getClassroomMovesByGrade(grade: Int, classNum: Int) async throws -> ClassroomMoveListResponseDTO
    func updateApplicationStatus(status: String, idList: [String]) async throws
    func updateClassroomMoveStatus(status: String, idList: [String]) async throws
}
