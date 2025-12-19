import Foundation

public protocol GetEarlyReturnByGradeUseCaseProtocol {
    func execute(grade: Int, classNum: Int) async throws -> [EarlyReturnAcceptEntity]
}
