import Foundation

public protocol GetSelfStudyDirectorUseCaseProtocol {
    func execute() async throws -> [SelfStudyDirectorEntity]
}
