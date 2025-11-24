import Foundation
import AcceptDomainInterface
import Combine

public class GetAllApplicationsUseCase: GetAllApplicationsUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute() -> AnyPublisher<[ApplicationEntity], Error> {
        Future { promise in
            Task {
                do {
                    let applications = try await self.repository.getAllApplications()
                    promise(.success(applications))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
