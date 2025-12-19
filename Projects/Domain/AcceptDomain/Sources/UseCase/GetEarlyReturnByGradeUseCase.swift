import Foundation
import AcceptDomainInterface

public class GetEarlyReturnByGradeUseCase: GetEarlyReturnByGradeUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(grade: Int, classNum: Int) async throws -> [EarlyReturnAcceptEntity] {
        try await repository.getEarlyReturnByGrade(grade: grade, classNum: classNum)
    }
}
