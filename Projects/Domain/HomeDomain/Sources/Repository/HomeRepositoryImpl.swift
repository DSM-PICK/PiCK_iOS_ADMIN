import Foundation

class HomeRepositoryImpl: HomeRepository {
    private let dataSource: HomeDataSource

    init(dataSource: HomeDataSource) {
        self.dataSource = dataSource
    }

    func getSelfStudyDirector() async throws -> [SelfStudyDirectorEntity] {
        try await dataSource.getSelfStudyDirector().map { $0.toEntity() }
    }
}

extension SelfStudyDirectorResponseDTO {
    func toEntity() -> SelfStudyDirectorEntity {
        .init(floor: floor, teacherName: teacherName)
    }
}
