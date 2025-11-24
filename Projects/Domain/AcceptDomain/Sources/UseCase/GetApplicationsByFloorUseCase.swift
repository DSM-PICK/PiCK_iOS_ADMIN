import Foundation
import AcceptDomainInterface
import Combine

public class GetApplicationsByFloorUseCase: GetApplicationsByFloorUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(floor: Int) -> AnyPublisher<[ApplicationEntity], Error> {
        Future { promise in
            Task {
                do {
                    let applications = try await self.repository.getApplicationsByFloor(floor: floor)
                    promise(.success(applications))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
