import Foundation
import CheckSelfStudyTeacherDomainInterface

public class FetchSelfStudyTeacherUseCase: FetchSelfStudyTeacherUseCaseProtocol {
    private let repository: CheckSelfStudyTeacherRepository

    public init(repository: CheckSelfStudyTeacherRepository) {
        self.repository = repository
    }

    public func execute(date: String) async throws -> [SelfStudyTeacherEntity] {
        try await repository.getSelfStudyTeacher(date: date)
    }
}
