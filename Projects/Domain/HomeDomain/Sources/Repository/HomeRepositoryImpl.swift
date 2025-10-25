import Foundation
import HomeDomainInterface

public class HomeRepositoryImpl: HomeRepository {
    private let dataSource: HomeDataSource

    public init(dataSource: HomeDataSource) {
        self.dataSource = dataSource
    }

    public func getSelfStudyDirector(date: String) async throws -> [SelfStudyDirectorEntity] {
        try await dataSource.getSelfStudyDirector(date: date).map { $0.toEntity() }
    }
}

extension SelfStudyDirectorResponseDTO {
    func toEntity() -> SelfStudyDirectorEntity {
        .init(floor: floor, teacherName: teacherName)
    }
}
