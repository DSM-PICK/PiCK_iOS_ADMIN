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
}
