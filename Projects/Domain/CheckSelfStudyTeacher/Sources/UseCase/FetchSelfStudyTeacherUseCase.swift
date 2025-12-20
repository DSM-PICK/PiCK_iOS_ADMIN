import Foundation
import Combine
import CheckSelfStudyTeacherDomainInterface

public class FetchSelfStudyTeacherUseCase: FetchSelfStudyTeacherUseCaseProtocol {
    private let repository: CheckSelfStudyTeacherRepository

    public init(repository: CheckSelfStudyTeacherRepository) {
        self.repository = repository
    }

    public func execute(date: String) -> AnyPublisher<[SelfStudyTeacherEntity], Error> {
        repository.getSelfStudyTeacher(date: date)
    }
}
