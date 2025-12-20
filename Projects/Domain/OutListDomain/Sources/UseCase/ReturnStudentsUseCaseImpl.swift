import Foundation
import Combine
import OutListDomainInterface

public class ReturnStudentsUseCaseImpl: ReturnStudentsUseCase {

    private let repository: OutListRepository

    public init(repository: OutListRepository) {
        self.repository = repository
    }

    public func execute(ids: [String]) -> AnyPublisher<Void, Error> {
        repository.returnStudents(ids: ids)
    }
}
