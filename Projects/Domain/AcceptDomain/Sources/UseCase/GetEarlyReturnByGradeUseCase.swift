import Foundation
import AcceptDomainInterface
import Combine

public class GetEarlyReturnByGradeUseCase: GetEarlyReturnByGradeUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(grade: Int, classNum: Int) -> AnyPublisher<[EarlyReturnAcceptEntity], Error> {
        repository.getEarlyReturnByGrade(grade: grade, classNum: classNum)
    }
}
