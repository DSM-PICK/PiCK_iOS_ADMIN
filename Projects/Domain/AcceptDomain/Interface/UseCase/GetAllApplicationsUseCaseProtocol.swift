import Foundation
import Combine

public protocol GetAllApplicationsUseCaseProtocol {
    func execute() -> AnyPublisher<[ApplicationEntity], Error>
}
