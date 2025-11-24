import Foundation
import AcceptDomainInterface

public class AcceptRepositoryImpl: AcceptRepository {
    private let dataSource: AcceptDataSource

    public init(dataSource: AcceptDataSource) {
        self.dataSource = dataSource
    }

    public func getApplicationsByGrade(grade: Int, classNum: Int) async throws -> [ApplicationEntity] {
        try await dataSource.getApplicationsByGrade(grade: grade, classNum: classNum).map { $0.toEntity() }
    }

    public func getClassroomMovesByGrade(grade: Int, classNum: Int) async throws -> [ClassroomMoveEntity] {
        try await dataSource.getClassroomMovesByGrade(grade: grade, classNum: classNum).map { $0.toEntity() }
    }

    public func updateApplicationStatus(status: String, idList: [String]) async throws {
        try await dataSource.updateApplicationStatus(status: status, idList: idList)
    }

    public func updateClassroomMoveStatus(status: String, idList: [String]) async throws {
        try await dataSource.updateClassroomMoveStatus(status: status, idList: idList)
    }
}

extension ApplicationResponseDTO {
    func toEntity() -> ApplicationEntity {
        .init(
            id: id,
            userId: userId,
            userName: userName,
            start: start,
            end: end,
            grade: grade,
            classNum: classNum,
            num: num,
            reason: reason
        )
    }
}

extension ClassroomMoveResponseDTO {
    func toEntity() -> ClassroomMoveEntity {
        .init(
            id: userId,
            userId: userId,
            userName: userName,
            classroomName: classroomName,
            move: move,
            grade: grade,
            classNum: classNum,
            num: num,
            start: start,
            end: end
        )
    }
}
