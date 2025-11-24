import Foundation
import AcceptDomainInterface
import Combine

public class GetAllApplicationsUseCase: GetAllApplicationsUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(grade: Int, classNum: Int) -> AnyPublisher<[ApplicationEntity], Error> {
        Future { promise in
            Task {
                do {
                    let applications = try await self.repository.getApplicationsByGrade(grade: grade, classNum: classNum)
                    promise(.success(applications))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
