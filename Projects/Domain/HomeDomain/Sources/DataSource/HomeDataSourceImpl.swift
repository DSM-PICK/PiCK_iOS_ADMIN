import Foundation
import BaseDomain

class HomeDataSourceImpl: BaseRemoteDataSource<SelfStudyAPI>, HomeDataSource {
    func getSelfStudyDirector() async throws -> [SelfStudyDirectorResponseDTO] {
        try await request(.getSelfStudyDirector, res: [SelfStudyDirectorResponseDTO].self)
    }
}
