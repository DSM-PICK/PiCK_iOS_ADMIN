import Foundation
import ClassroomMoveListDomainInterface

public class ClassroomMoveListRepositoryImpl: ClassroomMoveListRepository {
    private let dataSource: ClassroomMoveListDataSource

    public init(dataSource: ClassroomMoveListDataSource) {
        self.dataSource = dataSource
    }

    public func getClassroomMoveByFloor(floor: Int) async throws -> [ClassroomMoveListEntity] {
        try await dataSource.getClassroomMoveByFloor(floor: floor).map { $0.toEntity() }
    }

    public func getClassroomMoveByClassroom(grade: Int, classNum: Int) async throws -> [ClassroomMoveListEntity] {
        try await dataSource.getClassroomMoveByClassroom(grade: grade, classNum: classNum).map { $0.toEntity() }
    }
}
