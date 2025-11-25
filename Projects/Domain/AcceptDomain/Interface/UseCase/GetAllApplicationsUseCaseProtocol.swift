import Foundation

public protocol GetAllApplicationsUseCaseProtocol {
    func execute(grade: Int, classNum: Int) async throws -> [ApplicationEntity]
}
