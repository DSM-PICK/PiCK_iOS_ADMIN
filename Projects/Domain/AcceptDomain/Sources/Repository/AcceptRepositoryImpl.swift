import Foundation
import AcceptDomainInterface
import Combine

public class AcceptRepositoryImpl: AcceptRepository {
    private let dataSource: AcceptDataSource

    public init(dataSource: AcceptDataSource) {
        self.dataSource = dataSource
    }

    public func getApplicationsByGrade(grade: Int, classNum: Int) -> AnyPublisher<[ApplicationEntity], Error> {
        dataSource.getApplicationsByGrade(grade: grade, classNum: classNum)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }

    public func getApplicationsByFloor(floor: Int) -> AnyPublisher<[ClassroomMoveEntity], Error> {
        dataSource.getApplicationsByFloor(floor: floor)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }

    public func getClassroomMovesByGrade(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveEntity], Error> {
        dataSource.getClassroomMovesByGrade(grade: grade, classNum: classNum)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }

    public func getEarlyReturnByGrade(grade: Int, classNum: Int) -> AnyPublisher<[EarlyReturnAcceptEntity], Error> {
        dataSource.getEarlyReturnByGrade(grade: grade, classNum: classNum)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }

    public func updateApplicationStatus(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        dataSource.updateApplicationStatus(status: status, idList: idList)
    }

    public func updateClassroomMoveStatus(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        dataSource.updateClassroomMoveStatus(status: status, idList: idList)
    }

    public func updateEarlyReturnStatus(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        dataSource.updateEarlyReturnStatus(status: status, idList: idList)
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

extension EarlyReturnResponseDTO {
    func toEntity() -> EarlyReturnAcceptEntity {
        .init(
            id: id,
            userName: userName,
            start: start,
            grade: grade,
            classNum: classNum,
            num: num,
            reason: reason
        )
    }
}
