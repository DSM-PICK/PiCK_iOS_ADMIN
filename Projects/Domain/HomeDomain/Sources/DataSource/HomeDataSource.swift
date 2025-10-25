import Foundation

protocol HomeDataSource {
    func getSelfStudyDirector() async throws -> [SelfStudyDirectorResponseDTO]
}
