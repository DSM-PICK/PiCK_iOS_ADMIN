import Foundation

protocol HomeRepository {
    func getSelfStudyDirector() async throws -> [SelfStudyDirectorEntity]
}
