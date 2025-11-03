import Foundation
import Combine

public protocol GetAdminSelfStudyInfoUseCaseProtocol {
    func execute() -> AnyPublisher<String, Error>
}
