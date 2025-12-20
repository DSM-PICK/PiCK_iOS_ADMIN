import Foundation
import Combine
import ClassroomMoveListDomainInterface

public class ClassroomMoveListRepositoryImpl: ClassroomMoveListRepository {
    private let dataSource: ClassroomMoveListDataSource

    public init(dataSource: ClassroomMoveListDataSource) {
        self.dataSource = dataSource
    }

    public func getClassroomMoveByFloor(floor: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error> {
        dataSource.getClassroomMoveByFloor(floor: floor)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }

    public func getClassroomMoveByClassroom(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error> {
        dataSource.getClassroomMoveByClassroom(grade: grade, classNum: classNum)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }
}
