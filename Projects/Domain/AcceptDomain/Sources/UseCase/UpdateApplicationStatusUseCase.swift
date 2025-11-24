import Foundation
import AcceptDomainInterface
import Combine

public class UpdateApplicationStatusUseCase: UpdateApplicationStatusUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        Future { promise in
            Task {
                do {
                    try await self.repository.updateApplicationStatus(status: status, idList: idList)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
