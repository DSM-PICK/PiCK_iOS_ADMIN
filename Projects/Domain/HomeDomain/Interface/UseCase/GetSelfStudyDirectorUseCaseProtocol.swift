import Foundation

public protocol GetSelfStudyDirectorUseCaseProtocol {
    func execute(date: String) async throws -> [SelfStudyDirectorEntity]
}
