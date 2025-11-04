import Foundation
import HomeDomainInterface
import Combine

public class HomeRepositoryImpl: HomeRepository {
    private let dataSource: HomeDataSource

    public init(dataSource: HomeDataSource) {
        self.dataSource = dataSource
    }

    public func getSelfStudyDirector(date: String) -> AnyPublisher<[SelfStudyDirectorEntity], Error> {
        dataSource.getSelfStudyDirector(date: date)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }
    
    public func getAdminSelfStudyInfo() -> AnyPublisher<String, Error> {
        dataSource.getAdminSelfStudyInfo()
    }
}

extension SelfStudyDirectorResponseDTO {
    func toEntity() -> SelfStudyDirectorEntity {
        .init(floor: floor, teacherName: teacherName)
    }
}
