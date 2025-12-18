import Foundation
import HomeDomainInterface
import Combine

public class GetSelfStudyAndClassroomUseCaseImpl: GetSelfStudyAndClassroomUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func execute() -> AnyPublisher<GetSelfStudyAndClassroomEntity, Error> {
        repository.getSelfStudyAndClassroom()
    }
}
